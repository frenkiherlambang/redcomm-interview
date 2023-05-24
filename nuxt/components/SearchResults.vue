<template>
  <div>
    <ul class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div v-if="deletedMessage">
        {{ deletedMessage }}
      </div>
      <li v-for="result in results" :key="result.id">
        <NoteItem :note="result" :key="result.id" @edit="showEditModal(result)"  @delete="deleteNote(result.id)"   />
      </li>
    </ul>
    <div v-if="isLoading" class="w-full m-2 flex justify-center">
      <!-- center -->

      <div role="status" class="w-full m-2 flex justify-center">
        <svg aria-hidden="true" class="w-12 h-12 mr-2 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
          viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="currentColor" />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentFill" />
        </svg>
        <span class="sr-only">Loading...</span>
      </div>

    </div>
    <div class="w-full flex justify-center mt-4" v-if="hasMorePages && !isLoading">
      <button @click="loadMoreResults" class="group relative inline-block focus:outline-none focus:ring" href="/download">
        <span
          class="absolute inset-0 translate-x-1.5 translate-y-1.5 bg-yellow-300 transition-transform group-hover:translate-y-0 group-hover:translate-x-0"></span>

        <span
          class="relative inline-block border-2 border-current px-8 py-3 text-sm font-bold uppercase tracking-widest text-black group-active:text-opacity-75">
          Load More
        </span>
      </button>

    </div>
  </div>
  <EditModal v-if="selectedResult" :note="selectedResult" @close-modal="closeEditModal" @note-updated="refeshResults" />
</template>

<script>

export default {
  props: {
    searchTerm: {
      type: String,
      required: true
    }
  },
  setup() {
    const config = useRuntimeConfig();
    return {
       baseUrl: config.public.baseUrl
      };
  },
  data() {
    return {
      results: [],
      currentPage: 1,
      hasMorePages: false,
      isLoading: false,
      selectedResult: null,
      deletedMessage: null
    };
  },
  created() {
    this.fetchResults();
    if (typeof window !== 'undefined') {
      window.addEventListener('scroll', this.handleScroll);
    }
  },
  destroyed() {
    if (typeof window !== 'undefined') {
      window.removeEventListener('scroll', this.handleScroll);
    }
  },
  watch: {
    searchTerm(newSearchTerm, oldSearchTerm) {
      if (newSearchTerm !== oldSearchTerm) {
        this.results = [];
        this.currentPage = 1;
        this.hasMorePages = false;
        this.fetchResults();
      }
    }
  },
  methods: {
    showEditModal(result) {
      this.selectedResult = result;
    },
    closeEditModal() {
      this.selectedResult = null;
    },
    fetchResults() {
      this.isLoading = true;
      // Assuming you have an API endpoint to fetch search results
      // Replace 'API_ENDPOINT' with your actual API endpoint
      const url = this.baseUrl + `/api/notes?search=${this.searchTerm}&page=${this.currentPage}`;

      // Make an API request to fetch the results
      // You can use any HTTP library like Axios or fetch here
      // Here, I'm using fetch as an example
      fetch(url)
        .then(response => response.json())
        .then(data => {
          this.results = this.results.concat(data.data);
          this.hasMorePages = data.current_page < data.last_page;
          this.isLoading = false;
        })
        .catch(error => {
          console.error('Error fetching search results:', error);
        });
    },
    refeshResults() {
      this.results = [];
      this.currentPage = 1;
      this.hasMorePages = false;
      this.fetchResults();
    },
    deleteNote(noteId) {
      console.log('deleteNote', noteId);
      // Perform deletion logic here, such as making an API call or modifying the data
      fetch(this.baseUrl + `/api/notes/${noteId}`, {
        method: 'DELETE'
      })
        .then(response  => () => {
          console.log('response', response);
          this.deletedMessage = 'Note deleted successfully';
        })
        .catch(error => {
          console.error('Error:', error);
        });
      // After deletion, you can update the results list if needed
      this.results = this.results.filter(result => result.id !== noteId);
    },
    loadMoreResults() {
      if (!this.isLoading && this.hasMorePages) {
        this.currentPage++;
        this.fetchResults();
      }
    },
    handleScroll() {
      const scrollPosition = window.innerHeight + window.pageYOffset;
      const pageHeight = document.documentElement.scrollHeight;
      const bottomOffset = 20; // Adjust the offset as needed
      if (
        scrollPosition > pageHeight - bottomOffset &&
        !this.isLoading &&
        this.hasMorePages
      ) {
        this.loadMoreResults();
      }
    }
  }
};
</script>
<template>
  <div class="container mx-auto px-4 sm:px-6 lg:px-8">
    <Splide :options="{ rewind: true, }" aria-label="My Favorite Images">
      <SplideSlide>
        <img class="w-full max-h-96" src="https://placehold.co/960x240" alt="Sample 1">
      </SplideSlide>
      <SplideSlide>
        <img class="w-full max-h-96" src="https://placehold.co/960x240" alt="Sample 1">
      </SplideSlide>
    </Splide>
    <div class="flex my-2 items-center">

      <Search @search="handleSearch" class="w-full " />
      <button @click="showAddNoteModal = true" class="group relative mt-2 ml-2 inline-block focus:outline-none focus:ring" href="/download">
          <span
            class="absolute inset-0 translate-x-0 translate-y-0 bg-gray-300 transition-transform group-hover:translate-y-1.5 group-hover:translate-x-1.5"></span>

          <span
            class="relative inline-block border-2 border-current px-8 py-3 text-sm font-bold uppercase tracking-widest">
            Add Note
          </span>
        
      </button>

    </div>
    <SearchResults :searchTerm="searchTerm"  />

  </div>

  <AddNoteModal v-show="showAddNoteModal" @close-modal="showAddNoteModal = false" />
</template>
<script>

import Search from '@/components/Search.vue';
import SearchResults from '@/components/SearchResults.vue';
import { Splide, SplideSlide } from '@splidejs/vue-splide';
// Default theme
import '@splidejs/vue-splide/css';
import { debounce } from 'lodash';


export default {

  data() {
    return {
      searchTerm: '',
      showAddNoteModal: false,

    };
  },
  methods: {

    // Debounced function
    debouncedSearch: debounce(function (searchTerm) {
      // Do something with the debounced function
      this.searchTerm = searchTerm;
      // console.log('Performing search:', this.inputValue);
    }, 500), // Debounce delay in milliseconds
    handleSearch(searchTerm) {
      // Call the debounced function
      this.debouncedSearch(searchTerm);
    }
  },
  components: {
    SearchResults,
    Splide,
    SplideSlide,
  }
};

</script>
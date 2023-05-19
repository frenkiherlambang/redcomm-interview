<template>
  <div class="container mx-auto px-4 sm:px-6 lg:px-8">

    <Search v-model="searchTerm" />
    <SearchResults :items="allItems" :searchTerm="searchTerm" />

  </div>
</template>
<script>

export default {
  data() {
    return {
      searchTerm: '',
      allItems: [] // Replace with your actual data source
    };
  },
  methods: {
    search() {
      // Perform any additional logic before filtering
    }
  },
  components: {
    SearchResults
  }
};
</script>
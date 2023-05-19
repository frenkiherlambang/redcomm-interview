<template>
    <div>
        <ul>
            <li v-for="result in filteredResults" :key="result.id">
                {{ result.title }}
            </li>
        </ul>
    </div>
</template>
  
<script>

export default {
    props: {
        items: {
            type: Array,
            default: () => []
        },
        searchTerm: {
            type: String,
            default: ''
        }
    },
    watch: {
        searchTerm(newTerm) {
            this.fetchResults(newTerm);
        }
    },
    async mounted() {
        await this.fetchResults(this.searchTerm);
    },
    methods: {
        async fetchResults(searchTerm) {
            try {
                //   const response = await axios.get(`https://api.example.com/search?query=${searchTerm}`);
                const response = await useFetch('https://api.example.com/search?query=${searchTerm}')
                this.items = response.data.results;
            } catch (error) {
                console.error(error);
            }
        }
    },
    computed: {
        filteredResults() {
            if (this.searchTerm.trim() === '') {
                return this.items;
            }
        }
    }
};
</script>
  
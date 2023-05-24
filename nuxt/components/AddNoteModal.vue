<template>
    <div class="fixed bg-gray-600 bg-opacity-75 top-0 bottom-0 left-0 right-0 flex z-10 justify-center"
        @click="$emit('close-modal')">

        <div @click.stop class=" relative block h-64 sm:h-80 mt-72 mx-4 lg:h-96">

            <form @submit.prevent="saveData">

                <div
                    class="relative flex flex-col h-full transform items-end justify-between border-2 border-black bg-white transition-transform ">

                    <div class="p-4 flex flex-col space-y-6 relative w-full sm:p-6 lg:p-8">
                        <div v-if="successMessage" class="flash-message">
                            <div role="alert" class="rounded border-s-4 border-green-500 bg-green-50 p-4">
                                <strong class="block font-medium text-green-800">  {{ successMessage }}</strong>

                            </div>
                           
                        </div>
                        <label for="Title"
                            class="relative block w-96 overflow-hidden border-b border-gray-200 bg-transparent pt-3 focus-within:border-blue-600">
                            <input type="title" id="Title" placeholder="title" v-model="title"
                                class="peer h-8 w-full border-none bg-transparent p-0 placeholder-transparent focus:border-transparent focus:outline-none focus:ring-0 sm:text-sm" />
                            <span class="text-red-600 text-sm">{{ formatErrorMessage(errors.title) }}</span>
                            <span
                                class="absolute start-0 top-2 font-bold -translate-y-1/2 text-xl text-gray-700 transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:text-sm peer-focus:top-2 peer-focus:text-xs">
                                Title
                            </span>
                        </label>
                        <label for="content"
                            class="relative block w-96 overflow-hidden border-b border-gray-200 bg-transparent pt-3 focus-within:border-blue-600">
                            <textarea id="content" placeholder="content" v-model="content"
                                class="peer lg:h-24 w-full border-none bg-transparent p-0 placeholder-transparent focus:border-transparent focus:outline-none focus:ring-0 sm:text-sm"></textarea>
                            <span class="text-red-600 text-sm">{{ formatErrorMessage(errors.content) }}</span>

                            <span
                                class="absolute start-0 top-3 -translate-y-1/2 pb-2 text-xl font-bold text-gray-700 transition-all peer-placeholder-shown:top-1/5 peer-placeholder-shown:text-sm peer-focus:top-2 peer-focus:text-xs">
                                Content
                            </span>
                        </label>
                    </div>
                    <div class="p-3">
                        <button type="submit" class="group relative inline-block ml-2 focus:outline-none focus:ring">
                            <span
                                class="absolute inset-0 translate-x-0 translate-y-0 bg-gray-300 transition-transform group-hover:translate-y-1.5 group-hover:translate-x-1.5"></span>

                            <span
                                class="relative inline-block border-2 border-current px-8 py-3 text-sm font-bold uppercase tracking-widest">
                                Save
                            </span>
                        </button>

                    </div>

                </div>
            </form>

        </div>

    </div>
</template>

<script>
export default {
    data() {
        return {
            title: '',
            content: '',
            errors: {},
            successMessage: ''

        }
    },
    setup() {
        const config = useRuntimeConfig();
        return {
            baseUrl: config.public.baseUrl
        };
    },
    methods: {
        saveData() {
            // reset the errors object
            this.errors = {};
            // Prepare the data to be sent to the API
            const postData = {
                title: this.title,
                content: this.content
            };

            // Send a POST request to your API endpoint
            fetch(this.baseUrl + '/api/notes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(postData)
            })
                .then(response => {
                    // Handle the API response if needed
                    if (response.ok) {
                        this.successMessage = 'Data saved successfully';
                        this.title = '';
                        this.content = '';
                        setTimeout(() => {
                            this.successMessage = '';
                        }, 3000);
                    } else {
                        if (response.status === 422) {
                            response.json().then(data => {
                                this.errors = data.errors;
                            })
                        }
                    }
                })

                .catch(error => {

                    // Handle any errors that occur during the API request
                    console.error(error);
                });
        },
        formatErrorMessage(errorMessage) {
            if (Array.isArray(errorMessage)) {
                return errorMessage[0];
            }
            return errorMessage;
        }

    }
    ,

}
</script>

<template>
    <form v-on:submit.prevent="createWorkingTime" method="post">
        <label>
            starting date :
        </label>
        <input type="date" id="startingDate" v-model="startingDate" required/>
        <label>
            ending date :
        </label>
        <input type="date" id="endingDate" v-model="endingDate" required/>
        <button type="submit">
        Créer un nouveau working Time
        </button>
        </form>
</template>

<script>
import axios from 'axios'
export default {
  components: {
  },
  props: {
    idUser: {
      type: Number,
    }
  },
  data () {
    return {
        startingDate: '',
        endingDate: '',
    }
  },
  mounted () {
  },
  created () {
  },
  computed: {
  },
  methods: {
    createWorkingTime(){
      axios.post("http://localhost:4000/api/workingtimes")
    }
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>
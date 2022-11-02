<template>
    <form v-on:submit.prevent="createWorkingTime" method="post">
        <label>
            starting date :
        </label>
        <input type="datetime-local" id="startingDate" v-model="startingDate" required/>
        <label>
            ending date :
        </label>
        <input type="datetime-local" id="endingDate" v-model="endingDate" required/>
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
        startingDate: null,
        endingDate: null,
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
      axios.post(`http://localhost:4000/api/workingtimes/${this.idUser}`,{
        workingtime: {
            start: new Date(this.startingDate).toISOString(),
            end: new Date(this.endingDate).toISOString(),
        }
      })
    }
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>
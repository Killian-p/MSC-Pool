<template>
  <button @click="userClocks">
        Créer un nouveau working Time
        </button>
</template>

<script>
// import axios from 'axios'
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
    }
  },
  mounted () {
  },
  created () {
  },
  computed: {
  },
  methods: {
    async userClocks(){
      console.log(new Date(Date.now()))
        // await axios.get(`http://localhost:4000/api/workingtimes/${this.idUser}`, {params :{
        //   start: new Date().toISOString(),
        // }})
    },
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>
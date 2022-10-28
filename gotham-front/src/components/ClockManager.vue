<template>
  <button @click="userClocks">
        Créer un nouveau working Time
        </button>
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
    }
  },
  mounted () {
  },
  created () {

  },
  computed: {
  },
  methods: {
    getLocalIsoString(){
      const timeZoneOffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
      return (new Date(Date.now() - timeZoneOffset)).toISOString().slice(0, -1);
    },
    userClocks(){
        axios.post(`http://localhost:4000/api/clocks/${this.idUser}`, {
          clock:{
            time: this.getLocalIsoString()
          }
        }).then(
          (res) => console.log(res)
          )
        .catch(
          console.error
          );
    },
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>
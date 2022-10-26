<template>
    <div class="navUser">
    <div class="nav">
        <div class="box">
            <a href="/">Se connecter</a>
                <div id="app">
                    <button @click=createUser()>
                        créer un utilisateur
                    </button>
                </div>
        </div>
        <div class="box">
            <a href="/workingTimes">workingTimes</a>
        </div>
        <div class="box">
            <a href="/workingTime">workingTime</a>
        </div>
        <div class="box">
            <a href="/clock">clock</a>
        </div>
        <div class="box">
            <a href="/chartManager">chartManager</a>
        </div>
    </div>
    
  </div>
</template>

<script>
import axios from 'axios'   
export default {
  components: {
  },
  props: [
  ],
  data () {
    return {
        count: 0
    }
  },
  mounted () {
  },
  created () {
  },
  computed: {
  },
  methods: {
    createUser(){
        let a;
        axios.get("http://localhost:4000/api/users")
        .then((response) => {
            a = response.data;
            console.log(response);
        })
        .catch(console.error);
        // axios.post('localhost:4000/api/users', {
        // username: 'victor',
        // email: 'Williams@quelquechose'
        // }).then((response) => {
        //     console.log(response);
        // });
    }
  },
  watch: {
  }
}
</script>

<style scoped>
.navUser{
    background-color: rgb(173, 173, 238);
    position: relative;
    top: 0;
    width: 100%;
    border: 1px;
    height: 10vh;
}
.nav{
    display: flex;
    justify-content: space-between;
}
.box{
    margin: 2px;
}
</style>
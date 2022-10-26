<template>
    <div class="navUser">
    <div class="nav">
        <div class="box">
            <a href="/">Se connecter</a>
            <div id="app">
                <form action="http://localhost:4000/api/users" method="post">
                <label>
                    Email :
                </label>
                <input name="email" type="email" id="email" required/>
                <label>
                    Username :
                </label>
                <input name="username" type="text" id="username" required/>
                <button type="submit">
                créer un utilisateur
                </button>

                </form>
                <button @click=seeUsers()>
                    voir la liste des utilisateurs
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
    seeUsers(){
        let a;
        axios.get("http://localhost:4000/api/users?email=williams@quelquechose")
        .then((response) => {
            a = response.data;
            console.log(a);
        })
        .catch(console.error);
    },
    createUser(){
        axios.post('http://localhost:4000/api/users/', { user :{
            username: 'victor',
            email: 'Williams@quelquechose'
        }
        }).then((response) => {
            console.log(response);
        }).catch(console.error);
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
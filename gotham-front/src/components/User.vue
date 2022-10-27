<template>
    <div class="navUser">
    <div class="nav">
        <div class="box">
            <a :v-if="idCurrentUser == null" href="/">Se connecter</a>
            <div v-if="!this.connected" id="app">
                <form v-on:submit.prevent="createUser" method="post">
                <label>
                    Email :
                </label>
                <input type="email" id="email" v-model="email" required/>
                <label>
                    Username :
                </label>
                <input type="text" id="username" v-model="username" required/>
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
        connected: false,
        username: '',
        email: '',
        idCurrentUser: null,
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
        axios.get("http://localhost:4000/api/users?email=Williams@quelquechose")
        .then((response) => {
            a = response.data;
            console.log(a);
        })
        .catch(console.error);
    },
    createUser(){
        axios.post('http://localhost:4000/api/users', {
            user:{
                username: this.username,
                email: this.email
            }
        })
        .then((res) => {
            console.log(res);
            this.idCurrentUser = res.data.data.id;

            // this.idCurrentUser = res.data.id
        }).catch(console.error)
        this.connected=true;
        // axios.post('http://localhost:4000/api/users/', { user :{
        //     username: 'victor',
        //     email: 'Williams@quelquechose'
        // }
        // }).then((response) => {
        //     console.log(response);
        // }).catch(console.error);
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
<template>
    <div class="navUser">
    <div class="nav">
        <div class="box">
            <div id="app">
                <form v-on:submit.prevent="createUser" method="post">
                    <div>
                        <label>
                    Email :
                </label>
                <input type="email" id="email" v-model="email" required/>
                    </div>
                <label>
                    Username :
                </label>
                <input type="text" id="username" v-model="username" required/>
                <div>
                    <button type="submit">
                        créer un utilisateur
                    </button>
                </div>
                

                </form>
                <!-- <button @click=seeUsers()>
                    voir la liste des utilisateurs
                </button> -->
            </div>
            <div class="box">
                <form v-on:submit.prevent="updateUser" method="put">
                    <div>
                        <label>
                    Email :
                </label>
                <input type="email" id="email" v-model="editEmail" required :disabled="idCurrentUser == null"/>
                    </div>
                <label>
                    Username :
                </label>
                <input type="text" id="username" v-model="editUsername" required :disabled="idCurrentUser == null"/>
                <div>
                    <button type="submit" :disabled="idCurrentUser == null">
                        modifier un utilisateur
                    </button>
                </div>
                

                </form>
            </div>
            <div class="box">
                a²
            </div>
            <div class="box">
                <button @click="deleteUser" :disabled="idCurrentUser == null">
                    Supprimer l'utilisateur
                </button>
            </div>
        </div>
        
    </div>
    
  </div>
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
        connected: false,
        username: '',
        email: '',
        idCurrentUser: null,
        editUsername: null,
        editEmail: null,
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
            this.$emit("logged", res.data.data.id)
            this.idCurrentUser = res.data.data.id;
            this.username= "";
            this.email= "";
        }).catch(console.error)
        this.connected=true;
    },
    updateUser(){
        axios.put(`http://localhost:4000/api/users/${this.idCurrentUser}`, {
            user:{
                username: this.editUsername,
                email: this.editEmail
            }
        })
        .then((res) => {
            console.log(res);
            this.$emit("logged", res.data.data.id)
            this.idCurrentUser = res.data.data.id;
            this.editUsername= "";
            this.editEmail= "";
        }).catch(console.error)
        this.connected=true;
    },
    deleteUser(){
        axios.delete(`http://localhost:4000/api/users/${this.idCurrentUser}`)
        .then(_ => {
            this.idCurrentUser = null;
        });
    },
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
    height: 20vh;
}
.nav{
    justify-content: space-between;
}

.box{
    display: flex;
    justify-content: space-between;
}

.createUser{
    flex-direction: column;
}
</style>
<template>
    <div class="navUser">
    <div class="nav">
            <div id="app">
                <div v-if="idCurrentUser == null">
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
                </div>
                
            </div>
            <div class="box" v-if="idCurrentUser == null">
                <form v-on:submit.prevent="getUser" method="get">
                    <div>
                        <label>
                    Email :
                </label>
                <input type="email" id="email" v-model="connectionEmail" required/>
                    </div>
                <label>
                    Username :
                </label>
                <input type="text" id="username" v-model="connectionUsername" required/>
                <div>
                    <button type="submit">
                        Se connecter
                    </button>
                </div>
                <span v-if="!userExists" style="color: red;">Identifiants incorrects</span>
                </form>
            </div>
            <div class="box" v-if="idCurrentUser != null">
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
            
            <div class="box" v-if="idCurrentUser != null">
                <button @click="deleteUser" :disabled="idCurrentUser == null">
                    Supprimer l'utilisateur
                </button>
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
        connectionUsername: null,
        connectionEmail: null,
        userExists: true,
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
            this.userExists = true;
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
    getUser(){
        axios.get('http://localhost:4000/api/users', { params: { username: this.connectionUsername, email: this.connectionEmail } })
        .then(_ => {
            if(_.data.data.length == 0){
                this.userExists = false;
            }else {
            this.idCurrentUser = _.data.data[0].id;
            this.$emit("logged", _.data.data[0].id)
            this.editEmail = this.connectionEmail;
            this.editUsername = this.connectionUsername;
            this.connectionUsername= "";
            this.connectionEmail= "";
            this.userExists = true;
            }
        })
        .catch(console.error);
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
    height: 20vh;
}
.nav{
    justify-content: space-between;
    display: flex;
    align-items: center;
    height: 100%;
}

.box{
    display: flex;
    justify-content: center;
    width: 50vw;
}

.createUser{
    flex-direction: column;
}
</style>
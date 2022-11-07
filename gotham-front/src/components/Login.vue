<template>
    <div class="mainbox">
        <div class="loginbox">
            <div class="tabbox">
                <button class="tabnav" @click="changeTab('sign_in')">
                    Connexion
                </button>
                <button class="tabnav" @click="changeTab('sign_up')">
                    Enregistrement 
                </button>
            </div>
                <div class="formbox">
                    <div class="label-column">
                        <div class="box">
                            <label>Email:</label>
                        </div>
                        <div class="box" v-if="currentTab == 'sign_up'">
                            <label>Username:</label>
                        </div>
                        <div class="box">
                            <label>Password:</label>
                        </div>
                    </div>
                    <div class="input-column">
                        <div class="box">
                            <input v-model="email"/>
                        </div>
                        <div class="box" v-if="currentTab == 'sign_up'">
                            <input v-model="username"/>
                        </div>
                        <div class="box">
                            <input v-model="password" type="password"/>
                        </div>
                    </div>
                    
                </div>
                <span style="color: red;">{{errorMessage}}</span>  
                <div style="display: flex;">
                    <div class="box" style="margin-right: 60px;" v-if="currentTab == 'sign_up'">
                        <button @click="createUser" class="buttons" type="button">
                            S'enregistrer
                        </button>
                    </div>
                    <div class="box" v-if="currentTab == 'sign_in'">
                        <button @click="getUser" class="buttons" type="button">
                            Se connecter
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
        password: '',
        userExists: true,
        currentTab: "sign_in",
        errorMessage: ''
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
        axios.post(`http://localhost:4000/api/users/sign_up`, {
            user:{
                username: this.username,
                email: this.email,
                password: this.password,
            }
        })
        .then((res) => {
            localStorage.setItem("token", res.data.token);
            this.$emit("logged", res.data.id)
            this.username= "";
            this.email= "";
            this.userExists = true;
        }).catch(console.error)
        this.connected=true;
    },
    getUser(){
        axios.post(`http://localhost:4000/api/users/sign_in`, {
            password: this.password,
            email: this.email,
         })
        .then(_ => {
            localStorage.setItem("token", _.data.token);
            this.idCurrentUser = _.data.id;
            this.$emit("logged", [_.data.id, _.data.roles]);
            this.$emit("username", _.data.username);
            this.userExists = true;
            
        })
        .catch(_ => {
            this.errorMessage = _.message ?? _.response.data.message;
        });
    },
    changeTab(tab){
        this.currentTab = tab;
    }
  },
  watch: {
  }
}
</script>

<style>
.mainbox{
    width: 90vw;
    height: 100%;
    justify-content: center;
    align-items: center;
    display: flex;
}

.loginbox{
    background-color: #00ABB3;
    height: 50%;
    width: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 45px;
    flex-direction: column;
    border: black 3px solid;
}

.label-column{
    display: flex;
    flex-direction: column;
    margin-right: 15px;
}

.input-column{
    display: flex;
    flex-direction: column;
}

.formbox{
    display: flex;
}

.box{
    margin-top: 4px;
}

.buttons{
  border-radius: 45px;
  width: 100%;
  height: 150%;
  background-color: #3C4048;
  color: #00ABB3;
}

.buttons:hover{
    background-color: #00ABB3;
    color: #3C4048;
}


.tabbox{
    display: flex;
}

.tabnav{
    margin: 10px;
    border: black 3px solid;
    background-color: #3C4048;
    color: #00ABB3;
}
.tabnav:hover{
    background-color: #00ABB3;
    color: #3C4048;
}
</style>
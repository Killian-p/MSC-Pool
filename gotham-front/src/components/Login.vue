<template>
    <div class="mainbox">
        <div class="loginbox">
                <div class="formbox">
                    <div class="label-column">
                        <div class="box">
                            <label>Email:</label>
                        </div>
                        <div class="box">
                            <label>Password:</label>
                        </div>
                    </div>
                    <div class="input-column">
                        <div class="box">
                            <input v-model="email"/>
                        </div>
                        <div class="box">
                            <input v-model="username" type="password"/>
                        </div>
                    </div>
                </div>
                <div style="display: flex;">
                    <div class="box" style="margin-right: 60px;">
                        <button @click="createUser" class="buttons" type="button">
                            S'enregistrer
                        </button>
                    </div>
                    <div class="box">
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
        idCurrentUser: null,
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
    getUser(){
        axios.get('http://localhost:4000/api/users', { params: { username: this.username, email: this.email } })
        .then(_ => {
            if(_.data.data.length == 0){
                this.userExists = false;
            }else {
            this.idCurrentUser = _.data.data[0].id;
            this.$emit("logged", _.data.data[0].id)
            this.editEmail = this.email;
            this.editUsername = this.username;
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
</style>
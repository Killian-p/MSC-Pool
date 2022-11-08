<template>
    <div>
        ~My Profile~
    </div>
    <div>
        <button @click="updateUser(currentUser.username, currentUser.email)">
            UPDATE USER
        </button>
    </div>
    <div style='background-color: #3C4048;color: #00ABB3'>
        <a>Username: </a>
        <input style='background-color: #3C4048;color: #00ABB3' type="text" v-model="currentUser.username"/>
    </div>
    <div style='background-color: #3C4048;color: #00ABB3'>
        <a>email: </a>
        <input style='background-color: #3C4048;color: #00ABB3' type="text" v-model="currentUser.email"/>
    </div>
    <div style='background-color: #3C4048;color: #00ABB3'>
        <a>role: </a>
        <a>
            {{currentUser.roles}}
        </a>
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
        users: [],
        currentUser: null,
    }
  },
  mounted () {
    
  },
  created () {
    this.getUser();
  },
  computed: {
  },
  methods: {
    getUser(){
        axios.get(`http://localhost:4000/api/users/${this.idUser}`)
        .then(res => {
            console.log(res)
            this.currentUser = res.data.data
        });
    },
    updateUser(name, mail){
        axios.put(`http://localhost:4000/api/users/${this.idUser}`, {
            user: {
                username: name,
                email: mail,
            }
        },{
            headers: {
                token: localStorage.getItem("token")
            }
        })
        .then(res => {
            alert("Update successful")
            this.currentUser = res.data.data
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
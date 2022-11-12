<template>
    <div class="background" @click="closeProfil">
    </div>
    <div class="profilModal">
        <div v-if="currentUser">
            <div style="display: flex;justify-content:center">
                <label>Username: </label>
                <input type="text" v-model="currentUser.username"/>
                
            </div>
            <div style="display: flex;justify-content:center">
                <label>email: </label>
                <input type="text" v-model="currentUser.email"/>
            </div>
            <div style="display: flex;justify-content:center">
                <label>role: </label>
                {{currentUser.roles}}
            </div>
            </div>
                <button @click="updateUser()">
                    UPDATE USER
                </button>
                <button @click="deleteUser">
                    DELETE USER
                </button>
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
        axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`)
        .then(res => {
            this.currentUser = res.data.data
        });
    },
    updateUser(){
        axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`, {
            user: {
                username: this.currentUser.username,
                email: this.currentUser.email,
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
    },
    closeProfil(){
        this.$emit("profil");
    },
    deleteUser(){
        axios.delete(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`, { headers: {
        token: localStorage.getItem("token")
        }})
      .then((res) => {
        this.$emit("deleteuser");
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

.profilModal{
    position: fixed;
    background-color: #d9d9d9;
    border-radius: 16px;
    width: 400px;
    height: 200px;
    border: solid #3c4048 1px;
    opacity: 2;
    padding-top: 15px;
}

.background{
    background-color: black;
    opacity: 50%;
    width: 100vw;
    height: 100vh;
    top: 0;
    left: 215px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
}
</style>
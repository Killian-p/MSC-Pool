<template>
    USER MANAGEMENT
    <table>
      <thead>
        <th>USERNAME</th>
        <th>ROLE</th>
        <th>EMAIL ADDRESS</th>
      </thead>
      <tbody>
        <tr v-for="employee in users">
            <td 
                :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
                @click="this.selectedUserId = employee.id"
            >
                <input type="text" :value="employee.username" readonly/>
            </td>

            <td 
                :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
                @click="this.selectedUserId = employee.id"
            >
                <input type="text" :value="employee.roles" readonly/>
            </td>
            <td 
                :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
                @click="this.selectedUserId = employee.id"
            >{{employee.email}}</td>
        </tr>
      </tbody>
    </table>
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
    this.getAllUsers();
  },
  computed: {
  },
  methods: {
    getAllUsers(){
        let a;
        axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/users`, { headers: {
                token: localStorage.getItem("token")
            }})
        .then((res) => {
            console.log(res)
            this.users = res.data.data.filter((elem) => elem.roles !=="ADMIN")
        })
        .catch(console.error);
    },
    createUser(){
        axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/users`, {
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
        axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idCurrentUser}`, {
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
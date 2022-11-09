<template>
  DELETE USER(S)
  <table>
    <thead>
      <th>USERNAME</th>
      <th>ROLE</th>
      <th>EMAIL ADDRESS</th>
    </thead>
    <tbody>
      <tr v-for="employee in users.sort((a,b) => {return a.email > b.email})">
        <td
          :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
          @click="this.selectedUserId = employee.id"
        >
          {{employee.username}}
        </td>
        <td
          :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
          @click="this.selectedUserId = employee.id"
        >
          {{employee.roles}}
        </td>
        <td
          :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" 
          @click="this.selectedUserId = employee.id"
        >{{employee.email}}
        </td>
        <button @click="deleteUser((employee.id))">
          DELETE USER
        </button>
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
        selectedUserId: null,
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
    deleteUser(id){
      axios.delete(${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`, { headers: {
        token: localStorage.getItem("token")
        }})
      .then((res) => {
        this.users = this.users.filter((elem) => elem.id !== id);
        this.users = this.users;
        this.$emit("deleteuser", id);
      })
      .catch(console.error);
    },
    getAllUsers(){
      axios.get(${import.meta.env.VITE_BACKEND_URL}/api/users`, { headers: {
        token: localStorage.getItem("token")
        }})
      .then((res) => {
        this.users = res.data.data.filter((elem) => elem.roles !=="ADMIN")
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
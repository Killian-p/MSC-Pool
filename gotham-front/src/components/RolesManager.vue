<template>
    <table>
      <thead>
        <th>Id</th>
        <th>UserName</th>
        <th>Role</th>
        <th>Email</th>
      </thead>
      <tbody>
        <tr v-for="User in datas">
          <td @click="this.selectedUserId = User.id">{{User.id}}</td>
          <td>{{User.username}}</td>
          <td>{{User.roles}}</td>
          <td>{{User.email}}</td>
        </tr>
      </tbody>
    </table>
    <div>
        <button @click="setManager(selectedUserId)" id="Role1Button">
            ⟹
        </button>
    </div>
    <div>
        <button @click="setEmployee(selectedUserId)" id="Role2Button">
            ⟸
        </button>
    </div>
    
    <table>
      <thead>
        <th>Id</th>
        <th>UserName</th>
        <th>Role</th>
        <th>Email</th>
      </thead>
      <tbody>
        <tr v-for="User in datas">
          <td>{{User.id}}</td>
          <td>{{User.username}}</td>
          <td>{{User.roles}}</td>
          <td>{{User.email}}</td>
        </tr>
      </tbody>
    </table>
  </template>
  
  <script>
  import axios from 'axios'
  export default {
    props: {
    },
    data () {
      return {
        datas: null,
        selectedUserId: null,
      }
    },
    mounted () {
      this.getUsers();
    },
    created () {
      
    },
    computed: {
    },
    methods: {
        getUsers(){
            console.log(localStorage.getItem("token"));
            axios.get(`http://localhost:4000/api/users`, { headers: {
                token: localStorage.getItem("token")
            }}).then(_ => {
                console.log(_);
                this.datas = _.data.data
            }).catch(console.error);
        },
        setManager(id){
            axios.put(`http://localhost:4000/api/users/${id}`, {
              user:{
                    roles: "MANAGER"
                },
              }, {
              headers:{
                    token: localStorage.getItem("token")
                },
            } ).then((res) => {
            }).catch(console.error)
        },
        setEmployee(id){
            axios.put(`http://localhost:4000/api/users/${id}`, {
                user:{
                    roles: "EMPLOYEE"
                },
                headers:{
                    token: localStorage.getItem("token")
                }
            }).then((res) => {
            }).catch(console.error)
        },
    },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  
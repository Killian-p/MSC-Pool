<script setup>
import User from './User.vue';
</script>
<template>
  MANAGERS
    <table>
      <thead>
        <th>USERNAME</th>
        <th>ROLE</th>
        <th>EMAIL ADDRESS</th>
      </thead>
      <tbody>
        <tr v-for="employee in employees.sort((a,b) => {return a.email > b.email})">
          <td :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = employee.id">{{employee.username}}</td>
          <td :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = employee.id">{{employee.roles}}</td>
          <td :style="this.selectedUserId == employee.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = employee.id">{{employee.email}}</td>
        </tr>
      </tbody>
    </table>
    <div>
        <button @click="setManager(selectedUserId), this.selectedUserId = null" id="Role1Button">
            ⟹
        </button>
    </div>
    <div>
        <button @click="setEmployee(selectedUserId), this.selectedUserId = null" id="Role2Button">
            ⟸
        </button>
    </div>
      EMPLOYEES
    <table>
      <thead>
        <th>USERNAME</th>
        <th>ROLE</th>
        <th>EMAIL ADDRESS</th>
      </thead>
      <tbody>
        <tr v-for="manager in managers.sort((a,b) => {return a.email > b.email})">
          <td :style="this.selectedUserId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = manager.id">{{manager.username}}</td>
          <td :style="this.selectedUserId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = manager.id">{{manager.roles}}</td>
          <td :style="this.selectedUserId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedUserId = manager.id">{{manager.email}}</td>
        </tr>
      </tbody>
    </table>
    <User>

    </User>
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
        employees: [],
        managers: [],
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
            axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/users`, { headers: {
                token: localStorage.getItem("token")
            }}).then(res => {
                this.employees = res.data.data.filter((elem) => elem.roles === "EMPLOYEE")
                this.managers = res.data.data.filter((elem) => elem.roles === "MANAGER")
            }).catch(console.error);
        },
        setManager(id){
            axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`, {
              user:{
                    roles: "MANAGER"
                },
              }, {
                headers:{
                  token: localStorage.getItem("token")
                },
              } ).then((res) => {
                console.log(res.data.data.roles)
                this.employees = this.employees.filter((elem) => elem.id !== res.data.data.id)
                this.managers.push(res.data.data)
              }).catch(console.error)
            },
        setEmployee(id){
            axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`, {
              user:{
                    roles: "EMPLOYEE"
                },
              }, {
              headers:{
                    token: localStorage.getItem("token")
                }}).then((res) => {
                  this.managers = this.managers.filter((elem) => elem.id !== res.data.data.id)
                  this.employees.push(res.data.data)
            }).catch(console.error)
        },
    },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  
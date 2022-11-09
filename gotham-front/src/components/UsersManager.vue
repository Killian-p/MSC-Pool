<script setup>
import User from './User.vue';
</script>
<template>
  <div style="display: flex;align-items: center;justify-content: space-between;">
    <div style="margin: 50px;width: 475px;align-items: center;justify-content: space-between;background-color: white;border-radius: 45px;height: 500px;padding: 15px;">
      <div style="display: flex;align-items: center;align-self: center;margin: 10px;justify-content: center;">
        <p>EMPLOYEES</p>
      </div>
      <div>
        <div style="display: flex;margin: 10px;">
          <p style="display:flex;flex:1;justify-content:center;">USERNAME</p>
          <p style="display:flex;flex:1;justify-content:center;">ROLE</p>
          <p style="display:flex;flex:1;justify-content:center;">EMAIL ADDRESS</p>
        </div>
        <div style="max-height: 350px;overflow: auto">
          <div v-for="employee in employees.sort((a,b) => {return a.email > b.email})">
            <div :style="employee.id == selectedUserId ? 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 10px;background-color: #00ABB3;' 
            : 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 10px;'" @click="selectUser(employee.id, 'employee')">
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.username}}</p>
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.roles}}</p>
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.email}}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div style="margin-right: 30px;margin-left: 30px;">
      <div>
        <button @click="setManager(selectedUserId), this.selectedUserId = null" id="Role1Button" :disabled="selectedUserIs != 'employee'" class="transferButtons"
        >
            <img src="../../public/icons8-chevron-right-100.png"/>
        </button>
      </div>
      <div>
        <button @click="setEmployee(selectedUserId), this.selectedUserId = null" id="Role2Button" :disabled="selectedUserIs != 'manager'" class="transferButtons"
        >
        <img src="../../public/icons8-chevron-left-100.png"/>
        </button>
      </div>
    </div>
    <div style="margin: 50px;width: 475px;align-items: center;justify-content: space-between;background-color: white;border-radius: 45px;height: 500px;padding: 15px;">
      <div style="display: flex;align-items: center;align-self: center;margin: 10px;justify-content: center;">
        <p>MANAGERS</p>
      </div>
      <div>
        <div style="display: flex;margin: 10px;">
          <p style="display:flex;flex:1;justify-content:center;">USERNAME</p>
          <p style="display:flex;flex:1;justify-content:center;">ROLE</p>
          <p style="display:flex;flex:1;justify-content:center;">EMAIL ADDRESS</p>
        </div>
        <div style="max-height: 350px;overflow: auto">
          <div v-for="employee in managers.sort((a,b) => {return a.email > b.email})">
            <div :style="employee.id == selectedUserId ? 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 10px;background-color: #00ABB3;' 
            : 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 10px;'" @click="selectUser(employee.id, 'manager')">
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.username}}</p>
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.roles}}</p>
              <p style="display:flex;flex:1;justify-content:center;margin: 0;">{{employee.email}}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
      
    <!-- <User>

    </User> -->
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
        selectedUserIs: null,
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
                this.employees = this.employees.filter((elem) => elem.id !== res.data.data.id)
                this.managers.push(res.data.data)
              }).catch(console.error)
              this.selectedUserIs = null;
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
            this.selectedUserIs = null;
        },
        selectUser(id, role){
          this.selectedUserId = id;
          this.selectedUserIs = role;
        },
    },
    watch: {
    }
  }
  </script>
  <style scoped>
  .transferButtons{
    border-radius: 20px;
    background-color: #3C4048;
    color: #00ABB3;
  }

  .transferButtons:hover{
    background-color: #00ABB3;
    color: #3C4048;
  }

  .transferButtons:disabled{
    background-color: #3C4048;
  }
  </style>
  
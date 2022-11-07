<template>
    <table>
      <thead>
        <th>Id</th>
        <th>UserName</th>
        <th>Team's Name</th>
      </thead>
      <tbody>
        <tr v-for="User in datas">
          <td>{{User.id}}</td>
          <td>{{User.start}}</td>
          <td>{{User.end}}</td>
        </tr>
      </tbody>
    </table>
  </template>
  
  <script>
  import axios from 'axios'
  export default {
    props: {
      idUser: {
        type: Number,
      }
    },
    data () {
      return {
        datas: null,
      }
    },
    mounted () {
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.teamId}/users`)
        .then(_ => {
            console.log(_)
            this.datas = _.data.data;
          });
    },
    created () {
      
    },
    computed: {
    },
    methods: {
        
  
    },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  
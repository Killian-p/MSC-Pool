<template>
  <table>
    <thead>
      <th>Id</th>
      <th>Starts</th>
      <th>End</th>
    </thead>
    <tbody>
      <tr v-for="worktime in datas">
        <td>{{worktime.id}}</td>
        <td>{{worktime.start}}</td>
        <td>{{worktime.end}}</td>
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
    axios.get(${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`, { 
          headers:{
        token: localStorage.getItem("token")
      }}, {params :{
          start: new Date("1900-07-08T06:00:00Z").toISOString(),
        }}, ).then(_ => {
          this.datas = _.data.data;
          let start;
          let end;
          this.datas.forEach(x => {
            start = x.start.split("T");
            end = x.end.split("T");
            x.start = start[0] + " " + start[1];
            x.end = end[0] + " " + end[1];
          })
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

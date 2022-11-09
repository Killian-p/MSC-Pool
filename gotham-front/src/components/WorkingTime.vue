<template>
    <form v-on:submit.prevent="createWorkingTime" method="post">
      <label>
          starting date :
      </label>
      <input type="datetime-local" id="startingDate" v-model="startingDate" required/>
      <label>
          ending date :
      </label>
      <input type="datetime-local" id="endingDate" v-model="endingDate" required/>
      <button type="submit">
        Create a new Working Time
      </button>
    </form>
    <form v-on:submit.prevent="getWorkingTimesForAPerdiod" method="post">
      <label>
        starting date :
      </label>
      <input type="datetime-local" id="startingDate" v-model="startingDate" required/>
      <label>
        ending date :
      </label>
      <input type="datetime-local" id="endingDate" v-model="endingDate" required/>
      <button type="submit">
        Search Working Times
      </button>
    </form>
    <table>
      <thead>
        <tr>
          <th>
            Starting Date
          </th>
          <th>
            Ending Date
          </th>
          <th>
            Actions
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="items in this.datas" :key="items.id" >
          <th>
            {{items.id}}
            <input type="datetime-local" id="updateStartingDate" step="1" v-model="items.start" :readonly="!(this.idSelectedWorkingTime===items.id)" required/>
          </th>
          <th>
            <input type="datetime-local" id="updateEndingDate" step="1"  v-model="items.end" :readonly="!(this.idSelectedWorkingTime===items.id)" required/>
          </th>
          <th>
            <button @click="deleteAWorkingTime(items.id)">
              DELETE
            </button>
            <button v-if="!(this.idSelectedWorkingTime===items.id)" @click="this.idSelectedWorkingTime=items.id">
              UPDATE
            </button>
            <button v-if="(this.idSelectedWorkingTime===items.id)" @click="updateAWorkingTime(items.id, items.start, items.end), this.idSelectedWorkingTime=null">
              CONFIRM
            </button>
          </th>
        </tr>
      </tbody>
    </table>
      <!-- <ul id="displayWorkingTimes">
        <li v-for="items in this.datas" :key="items.id" >
          <input type="datetime-local" id="updateStartingDate" :value="items.start" required/>
          <input type="datetime-local" id="updateEndingDate" :value="items.end" readonly required/>
          <button @click="deleteAWorkingTime(items.id)">
            DELETE
          </button>
          <button v-if=this.updateMode @click="updateAWorkingTime(items.id, items.start, items.end), this.updateMode=!this.updateMode">
            UPDATE
          </button>
          <button v-if=!this.updateMode @click="updateAWorkingTime(items.id, items.start, items.end), this.updateMode=!this.updateMode">
            CONFIRM
          </button>
        </li>
      </ul> -->
    
  
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
        startingDate: null,
        endingDate: null,
        datas: [],
        updateMode: false,
        idSelectedWorkingTime: null,
    }
  },
  mounted () {
  },
  created () {
  },
  computed: {
  },
  methods: {
    updateAWorkingTime(idWorkingTime, start, end){
      axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${idWorkingTime}`, {
        workingtime:{
          start: new Date(start).toISOString(),
          end: new Date(end).toISOString(),
        }
      }, {headers: {
          token: localStorage.getItem("token")
        }}).catch(console.error)
    },
    deleteAWorkingTime(idWorkingTime){
      axios.delete(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${idWorkingTime}`, {headers: {
          token: localStorage.getItem("token")
        }}).catch(console.error)
      .then(() => {
        this.datas= this.datas.filter((elem) => elem.id!==idWorkingTime)
      })
    },
    getWorkingTimesForAPerdiod(){
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`, { 
        headers:{
          token: localStorage.getItem("token"),
        }, 
          params :{
          start: new Date(this.startingDate).toISOString(),
          end: new Date(this.endingDate).toISOString(),
        }
      }).then(res => {
        this.datas = res.data.data;
        let start;
        let end;
        this.datas.forEach(x => {
          start = x.start.split("T");
          end = x.end.split("T");
          x.start = start[0].split(".")[0] + " " + start[1].split(".")[0];
          x.end = end[0].split(".")[0] + " " + end[1].split(".")[0];
        })
      }).catch(console.error);
    },
    createWorkingTime(){
      axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`,{
        workingtime: {
            start: new Date(this.startingDate).toISOString(),
            end: new Date(this.endingDate).toISOString(),
        }
      }, {headers: {
          token: localStorage.getItem("token")
        }}).then((res) => {
        let start = res.data.data.start.split("T");
        let end = res.data.data.end.split("T");
        res.data.data.start = start[0] + " " + start[1];
        res.data.data.end = end[0] + " " + end[1];
        this.datas.push(res.data.data);
        })
      }
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>
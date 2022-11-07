<template>
  <div class="clock">
    <div class="sub">
      <div>
        User: {{username}}
      </div>
      <div>
        Status: {{clocking ? 'Clocking' : 'Not clocking'}}
      </div>
      <div style="margin-left: 25px; margin-top: 10px;">
        <a href="#" @click="clock">{{clocking ? 'Clock out' : 'Clock in'}}</a>
      </div>
    </div>
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
    },
    username: {
      type: String,
    }
  },
  data () {
    return {
      clocking: false,
    }
  },
  mounted () {
    this.getClock();
  },
  created () {

  },
  computed: {
  },
  methods: {
    getLocalIsoString(){
      const timeZoneOffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
      return (new Date(Date.now() - timeZoneOffset)).toISOString().slice(0, -1);
    },

    clock(){
      axios.post(`http://localhost:4000/api/clocks/${this.idUser}`, {
        clock: {
          time: this.getLocalIsoString(),
        }
      },
      { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        this.clocking = _.data.data.status;
      })
    },
    
    getClock(){
      axios.get(`http://localhost:4000/api/clocks/${this.idUser}`, { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        this.clocking = _.data.data.status;
      })
    }

  },
  watch: {
  }
}
</script>

<style scoped>


.button-clock{
  border-radius: 45px;
  width: 10vw;
  height: 5vh;
  margin-top: 30px;
  margin-left: 60px;
}
.button-in{
  background-color: #3C4048;
  color: #00ABB3;
}
.button-in:hover{
  background-color: #00ABB3;
  color: #3C4048;
}

.button-out{
  background-color: #00ABB3;
  color: #3C4048;
}

.clock{
  position: fixed;
  bottom: 0;
  border-radius: 20px;
  margin-bottom: 10px;
  margin-left: 10px;
  width: 9vw;
  height: 10vh;
  background-color: #B2B2B2;
}

.sub{
  margin-top: 10px;
  margin-left: 20px;
  font-size: small;
}
</style>
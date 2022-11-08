<template>
  <div class="clock">
    <div class="sub">
      <div style="display: flex;">
        <div>
          User: {{username}}
        </div>
        <div style="margin-left: 55px;">
          {{clocking ?  `${timer/3600<10 ? 0 : ''}${~~(timer/3600)}:${(timer%3600)/60<10 ? 0 : ''}${~~((timer%3600)/60)}:${(timer%3600)%60<10 ? 0 : ''}${(timer%3600)%60}` : '00:00:00'}}
        </div>
      </div>
      <div>
        Status: {{clocking ? 'Clocking' : 'Not clocking'}}
      </div>
      <div style="margin-left: 45px; margin-top: 10px;">
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
      lastTime: null,
      timer: null,
      timerHour: null,
      timerMinute: null,
      timerSecond: null,
    }
  },
  mounted () {
    this.getClock();
    setInterval(this.addTime, 1000);
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
      axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/clocks/${this.idUser}`, {
        clock: {
          time: this.getLocalIsoString(),
        }
      },
      { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        this.lastTime = _.data.data.time;
        this.setTimer();
        this.clocking = _.data.data.status;
      })
    },
    
    getClock(){
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/clocks/${this.idUser}`, { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        this.lastTime = _.data.data.time;
        this.clocking = _.data.data.status;
        this.setTimer();
      })
    },

    setTimer(){
      debugger;
      this.timer = Math.floor((Date.now() - new Date(this.lastTime).valueOf())/1000);
    },

    addTime(){
      this.timer ++;
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
  margin-left: 0px;
  width: 175px;
  height: 80px;
  background-color: #B2B2B2;
}

.sub{
  margin-top: 10px;
  margin-left: 20px;
  font-size: small;
}
</style>
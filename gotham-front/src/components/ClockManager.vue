<template>
  <div class="clock">
    {{ clocking ? `${timer / 3600 < 10 ? 0 : ""}${~~(timer / 3600)}:${(timer % 3600) / 60 < 10 ? 0 : ""}${~~((timer % 3600) / 60)}:${(timer % 3600) % 60 < 10 ? 0 : ""}${(timer % 3600) % 60}` : "00:00:00" }}
    <div>Status: {{ clocking ? "Clocking" : "Not clocking" }}</div>
    <a href="#" @click="clock">{{ clocking ? "Clock out" : "Clock in" }}</a>
  </div>
</template>

<script>
import axios from "axios";
export default {
  components: {},
  props: {
    idUser: {
      type: Number,
    },
    username: {
      type: String,
    },
  },
  data() {
    return {
      clocking: false,
      lastTime: null,
      timer: null,
      timerHour: null,
      timerMinute: null,
      timerSecond: null,
    };
  },
  mounted() {
    this.getClock();
    setInterval(this.addTime, 1000);
  },
  created() {},
  computed: {},
  methods: {
    getLocalIsoString() {
      const timeZoneOffset = new Date().getTimezoneOffset() * 60000; //offset in milliseconds
      return new Date(Date.now() - timeZoneOffset).toISOString().slice(0, -1);
    },

    clock() {
      axios
        .post(
          `${import.meta.env.VITE_BACKEND_URL}/api/clocks/${this.idUser}`,
          {
            clock: {
              time: this.getLocalIsoString(),
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((_) => {
          this.lastTime = _.data.data.time;
          this.setTimer();
          this.clocking = _.data.data.status;
        });
    },

    getClock() {
      axios
        .get(`${import.meta.env.VITE_BACKEND_URL}/api/clocks/${this.idUser}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((_) => {
          this.lastTime = _.data.data?.time ?? null;
          this.clocking = _.data.data?.status ?? false;
          this.setTimer();
        });
    },

    setTimer() {
      this.timer = Math.floor((Date.now() - new Date(this.lastTime).valueOf()) / 1000);
    },

    addTime() {
      this.timer++;
    },
  },
  watch: {},
};
</script>

<style scoped>
.clock {
  padding: 10px;
  display: flex;
  align-items: center;
  gap: 10px;
  border-radius: 20px;
  flex-direction: column;
  width: 155px;
  background-color: #b2b2b2;
  font-size: small;
}
</style>

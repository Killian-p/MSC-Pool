<template>
  <body>
    <form v-on:submit.prevent="createWorkingTime" method="post">
      <label>starting date :</label>
      <input type="datetime-local" id="startingDate" v-model="startingDate" required/>
      <label>ending date :</label>
      <input type="datetime-local" id="endingDate" v-model="endingDate" required/>
      <button @click="seeWorkingTimes()">Search</button>
    </form>
    <div class ="barChart"><canvas id="bar-chart" width="450" height="100"></canvas></div>
    <div class ="pieChart"><canvas id="pie-chart" width="300" height="100"></canvas></div>
  </body>
</template>

<script>
import Chart from 'chart.js/auto';
import axios from 'axios';
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
      startTime: null,
      endTime: null,
      labelStart: null,
      labelEnd: null,
      arrayStart: null,
      arrayEnd: null,
      workTime: null,
      filteredData: null,
      sumWorktime: null,
      workingTimes: null,
      nightTimes: null,
      nightTimesBis: null,
      nightingTimes: null,
      startingDate: new Date(new Date().setDate(new Date().getDate() - 7)).toISOString().split("Z")[0].slice(0,16),
      endingDate: new Date().toISOString().split("Z")[0].slice(0,16),
    }
  },
  async mounted () {
    await this.seeWorkingTimes();
    this.SumFuction();
    //this.filterDate();
    new Chart(document.getElementById("bar-chart"), {
      type: 'bar',
      data: {
        labels: this.filteredData,
        color: "#3e95cd",
        datasets: [
          {
          data: this.workTime,
          label: "Normal Hours",
          backgroundColor: "#2ded02",
          fill: false
        },
        {
          data: [1,3,2,2,3,1,1,1,1],
          label: "Extra hours",
          backgroundColor: "#e9ed02",
          fill: false
        },
        {
          data: [1,3,2,2,3,1,1,1,1],
          label: "Night hours",
          backgroundColor: "#1e02ed",
          fill: false
        }]
      },
      options: {
        scales: {
          y: {
            ticks: { color: 'white', beginAtZero: true },
            stacked: true,
          },
          x: {
            ticks: { color: 'white', beginAtZero: true },
            stacked: true
          }
        },
        title: {
          display: true,
          text: 'Working times'
        },
        plugins: {
          legend: {
            display: true,
            labels: {color: 'rgb(255, 255, 255)'}
          }
        }
      }
    });
    new Chart(document.getElementById("pie-chart"), {
      type: 'pie',
      data: {
        labels: ["Normal", "Night", "Sup. Hours"],
        datasets: [{
          backgroundColor: ["#48cd3e", "#453ecd", "#cdc33e"],
          data: [this.sumWorktime,50, 10]
        }]
      },
      options: {
        title: {
          display: true,
          text: 'Hours type'
        },
        plugins: {
          legend: {
            display: true,
            position: 'right',
            labels: {color: 'rgb(255, 255, 255)'}
          }
        }
      }
    });
  },
  created () {
    
  },
  computed: {
  },
  methods: {
    async seeWorkingTimes(){
        await axios.get(`http:/localhost:4000/api/workingtimes/${this.idUser}`, {params :{
          start: new Date("2010-01-01T01:01").toISOString(),
        }})
        .then((response) => {
          let arrayOfDates = response.data.data;
          this.labelStart = new Array();
          this.labelEnd = new Array();
          this.workTime = new Array();
          this.workingTimes = new Array();
          this.nightTimes = new Array();
          this.nightTimesBis = new Array();
          this.nightingTimes = new Array();
          arrayOfDates.forEach(_ => {
            this.arrayStart = _.start.split("T");
            this.arrayEnd = _.end.split("T");
            this.labelStart.push(this.arrayStart[0].toString());
            this.labelEnd.push(this.arrayEnd[0].toString());

            if(this.arrayEnd[0] != this.arrayStart[0]){

              this.nightTimes.push((((new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime())/3600000)));
              
              console.log(this.nightTimes);
              console.log(_.start);
              console.log(_.end);
              console.log("===========")

              this.nightTimesBis.push(((new Date(_.end).getTime() - new Date(_.start).getTime())/3600000)-this.nightTimes);
              console.log(this.nightTimesBis);

              this.nightingTimes = [this.nightTimes, this.arrayStart[0]];
              this.nightingTimes = [this.nightTimesBis, this.arrayEnd[0]];
                           
            }else{
              
              this.workTime.push((new Date(_.end).getTime() - new Date(_.start).getTime())/3600000);
              this.workingTimes = [this.workTime, this.arrayStart[0]];
            }
          })
        })
        .catch(console.error);
    },
    filterDate(){
      this.filteredData = new Array;
      this.workingTimes[1].forEach(_ => {
        if(new Date(_) >= new Date(this.startingDate) && new Date(_) <= new Date(this.endingDate)){
          this.filteredData.push(_);
        }
      });
    },
    SumFuction() {
      this.workTime.forEach(element => {
        this.sumWorktime += element;
      });
    },
  },
  watch: {
  }
}
</script>
<style scoped>
</style>
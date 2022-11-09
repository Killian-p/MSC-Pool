<template>
  <body>
    <form v-on:submit.prevent="createWorkingTime" method="post">
      <label>starting date :</label>
      <input type="date" id="startingDate" v-model="startingDate" required/>
      <label>ending date :</label>
      <input type="date" id="endingDate" v-model="endingDate" required/>
      <button @click="searchDate()">Search</button>
    </form>
    <div>
      <div style="width: 100%;">
        <div class ="barChart" style="margin-bottom: 10px; margin-right: 10px;margin-left: 25px;"><canvas id="bar-chart" width="800" height="150"></canvas></div>
      </div>
      <div style="display: flex; width: 100%;justify-content: space-between;flex: 1;align-items: center;">
        <div class ="doughnutChart" style="margin-bottom: 10px; margin-right: 10px;margin-left: 40px;"><canvas id="doughnut-chart" width="300" height="150"></canvas></div>
        <div class ="lineChart" style="margin-bottom: 10px; margin-right: 10px;"><canvas id="line-chart1" width="400" height="150"></canvas></div>
      </div>
      <div style="display: flex; width: 100%;justify-content: space-between;flex: 1;">
        <div class ="lineChart" style="margin-bottom: 10px; margin-right: 40px;margin-left: 25px;"><canvas id="line-chart2" width="500" height="150"></canvas></div>
        <div class ="lineChart" style="margin-bottom: 10px; margin-right: 10px;"><canvas id="line-chart3" width="500" height="150"></canvas></div>
      </div>
    </div>

    

        

        
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
      dataWork: null,
      dataWorkUnique: null,
      labelDate: null,
      supHours: null,
      nightHours: null,
      workHours: null,
      arrayStart: null,
      arrayEnd: null,
      
      filteredData: null,//?

      workTime: null,
      nightTimes: null,
      nightTimesBis: null,

      sumSupHours: null,
      sumWorktime: null,
      sumNightTimes: null,

      startingDate: null,
      endingDate: null,

      searchEnd: null,
      searchStart: null,
      
      // startingDate: new Date(new Date().setDate(new Date().getDate() - 7)).toISOString().split("Z")[0].slice(0,16),
      // endingDate: new Date().toISOString().split("Z")[0].slice(0,16),
    }
  },
  async mounted () {
    await this.getWorkingTimes();
    this.date();
    this.seeWorkingTimes();
  },
  created () {
    
  },
  computed: {
  },
  methods: {
    seeWorkingTimes(){
      new Chart(document.getElementById("bar-chart"), {
      type: 'bar',
      data: {
        labels: (this.labelDate),
        color: "#3e95cd",
        datasets: [
          {
            data: (this.workHours),
            label: "Normal Hours",
            backgroundColor: "#8BBCCC",
            fill: false
          },
          {
            data: (this.supHours),
            label: "Extra hours",
            backgroundColor: "#4C6793",
            fill: false
          },
          {
            data: (this.nightHours),
            label: "Night shifts",
            backgroundColor: "#5C2E7E",
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
          plugins: {
            legend: {
              display: true,
              labels: {color: 'rgb(255, 255, 255)'}
            }
          }
        }
      });
      new Chart(document.getElementById("doughnut-chart"), {
        type: 'doughnut',
        data: {
          labels: ["Normal", "Night", "Sup. Hours"],
          datasets: [{
            backgroundColor: ["#8BBCCC", "#4C6793", "#5C2E7E"],
            data: [this.sumWorktime,this.sumNightTimes, this.sumSupHours]
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
      new Chart(document.getElementById("line-chart1"), {
      type: 'line',
      data: {
        labels: (this.labelDate),
        color: "#3e95cd",
        datasets: [
          {
            data: (this.workHours),
            label: "Normal Hours",
            backgroundColor: "#FFF",
            borderColor: '#FFF',
            fill: {
              target: 'origin',
              above: "#8BBCCC",
              below: "#FFF"
            },
            pointRadius: 0,
            tension: 0.3,
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
          plugins: {
            legend: {
              display: false,
              labels: {color: 'rgb(255, 255, 255)'}
            }
          }
        }
      });
      new Chart(document.getElementById("line-chart2"), {
      type: 'line',
      data: {
        labels: (this.labelDate),
        color: "#3e95cd",
        datasets: [
          {
            data: (this.supHours),
            label: "Sup Hours",
            backgroundColor: "#FFF",
            borderColor: '#FFF',
            fill: {
              target: 'origin',
              above: "#4C6793",
              below: "#FFF"
            },
            pointRadius: 0,
            tension: 0.3,
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
          plugins: {
            legend: {
              display: false,
              labels: {color: 'rgb(255, 255, 255)'}
            }
          }
        }
      });
      new Chart(document.getElementById("line-chart3"), {
      type: 'line',
      data: {
        labels: (this.labelDate),
        color: "#3e95cd",
        datasets: [
          {
            data: (this.nightHours),
            label: "Night Shifts",
            backgroundColor: "#FFF",
            borderColor: '#FFF',
            fill: {
              target: 'origin',
              above: "#5C2E7E",
              below: "#FFF"
            },
            pointRadius: 0,
            tension: 0.3,
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
          plugins: {
            legend: {
              display: false,
              labels: {color: 'rgb(255, 255, 255)'}
            }
          }
        }
      });
    },
    
    async getWorkingTimes(){
        await axios.get(${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`, { 
          headers:{
        token: localStorage.getItem("token")
      }}, {params :{
          start: new Date("2010-01-01T01:01").toISOString(),
        }})
        .then((response) => {
          let arrayOfDates = response.data.data;
          this.workTime = new Array();
          this.nightTimes = new Array();
          this.nightTimesBis = new Array();
          this.dataWork = new Array();
          arrayOfDates.forEach(_ => {
            this.arrayStart = _.start.split("T");
            this.arrayEnd = _.end.split("T");

            if(this.arrayEnd[0] != this.arrayStart[0]){

              //Calculate worked hours for the first day of the night shift
              this.nightTimes = ((((new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime())/3600000)-1));
              //Calculate worked hours for the second day of the night shift
              this.nightTimesBis = (((new Date(_.end).getTime() - new Date(_.start).getTime())/3600000)-((((new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime())/3600000)-1)));
              
              //Put data for the first day of the night shift
              this.dataWork.push({
                date:this.arrayStart[0],
                workTime:0,
                supTime:0,
                nightTime:this.nightTimes,
              });
              //Put data for the second day of the night shift
              this.dataWork.push({
                date:this.arrayEnd[0],
                workTime:0,
                supTime:0,
                nightTime:this.nightTimesBis,
              })
            }else{
              this.workTime = ((new Date(_.end).getTime() - new Date(_.start).getTime())/3600000);
              this.dataWork.push({
                date:this.arrayStart[0],
                workTime:this.workTime,
                supTime:0,
                nightTime:0,
              });
            }
          })
        })
        .catch(console.error);
    },
    date(){
      this.dataWork.sort((a,b) => new Date(a.date) - new Date(b.date));
      let i;
      for(i=0;i<(this.dataWork.length-1); i++){
        if(this.dataWork[i].date == this.dataWork[i+1].date){
          this.dataWork[i].workTime = this.dataWork[i].workTime + this.dataWork[i+1].workTime
          this.dataWork[i+1].workTime = 0
          this.dataWork[i].supTime = this.dataWork[i].supTime + this.dataWork[i+1].supTime
          this.dataWork[i+1].supTime = 0
          this.dataWork[i].nightTime = this.dataWork[i].nightTime + this.dataWork[i+1].nightTime
          this.dataWork[i+1].nightTime = 0
        }
      }
      for(i=0;i<(this.dataWork.length-1); i++){
        if(this.dataWork[i].date == this.dataWork[i+1].date){
          this.dataWork[i].workTime = this.dataWork[i].workTime + this.dataWork[i+1].workTime
          this.dataWork[i+1].workTime = 0
          this.dataWork[i].supTime = this.dataWork[i].supTime + this.dataWork[i+1].supTime
          this.dataWork[i+1].supTime = 0
          this.dataWork[i].nightTime = this.dataWork[i].nightTime + this.dataWork[i+1].nightTime
          this.dataWork[i+1].nightTime = 0
        }
      }
      this.deleteBlankDate();
      this.getHourSup();
      this.SumFuction();
      this.workTimeGroup();
    },
    deleteBlankDate(){
      this.dataWorkUnique = new Array();
      let i;
      for(i=0;i<(this.dataWork.length); i++){
        if(this.dataWork[i].workTime != 0 || this.dataWork[i].nightTime != 0){
          this.dataWorkUnique.push(this.dataWork[i]);
        }
      }
    },
    getHourSup(){
      let i;
      for(i=0;i<(this.dataWorkUnique.length);i++){
        if(this.dataWorkUnique[i].workTime > 8){
          this.dataWorkUnique[i].supTime = this.dataWorkUnique[i].workTime - 8;
          this.dataWorkUnique[i].workTime = 8;
        }
      }
    },
    SumFuction() {
      let i;
      for(i=0;i<(this.dataWorkUnique.length); i++){
        this.sumWorktime += this.dataWorkUnique[i].workTime;
        this.sumNightTimes += this.dataWorkUnique[i].nightTime;
        this.sumSupHours += this.dataWorkUnique[i].supTime;
      }
    },
    workTimeGroup(){
      let i;
      this.labelDate = new Array();
      this.workHours = new Array();
      this.nightHours = new Array();
      this.supHours = new Array();
      for(i=0;i<(this.dataWorkUnique.length); i++){
        this.labelDate.push(this.dataWorkUnique[i].date),
        this.workHours.push(this.dataWorkUnique[i].workTime),
        this.nightHours.push(this.dataWorkUnique[i].nightTime),
        this.supHours.push(this.dataWorkUnique[i].supTime)
      }
    },
    searchDate(){
      this.searchStart = new Date(this.startingDate).toISOString().split("T")[0],
      this.searchEnd = new Date(this.endingDate).toISOString().split("T")[0]
      let i;
      this.labelDate=[]
      this.workHours=[]
      this.nightHours=[]
      this.supHours=[]
      for(i=0;i<(this.dataWorkUnique.length); i++){
        if(new Date(this.dataWorkUnique[i].date)>=new Date(this.searchStart) && new Date(this.dataWorkUnique[i].date)<=new Date(this.searchEnd)){
          this.labelDate.push(this.dataWorkUnique[i].date),
          this.workHours.push(this.dataWorkUnique[i].workTime),
          this.nightHours.push(this.dataWorkUnique[i].nightTime),
          this.supHours.push(this.dataWorkUnique[i].supTime)
        }
      }
      var chartExist = Chart.getChart("bar-chart"); 
      var char2Exist = Chart.getChart("doughnut-chart");
      if (chartExist != undefined){
        chartExist.destroy();
        char2Exist.destroy();
        this.seeWorkingTimes();
      } 
      
    },
  },
  watch: {
  }
}
</script>
<style scoped>

</style>
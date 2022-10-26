<template>
  <div class="navUser">
    <div class="nav">
        <div class="box">
            <a href="/">Se connecter</a>
        </div>
        <div class="box">
            <a href="/workingTimes">workingTimes</a>
        </div>
        <div class="box">
            <a href="/workingTime">workingTime</a>
        </div>
        <div class="box">
            <a href="/clock">clock</a>
        </div>
        <div class="box">
            <a href="/chartManager">chartManager</a>
        </div>
    </div>
    
  </div>
</template>

<style scoped>
.navUser{
    background-color: rgb(173, 173, 238);
    position: relative;
    top: 0;
    width: 100%;
    border: 1px;
    height: 10vh;
}
.nav{
    display: flex;
    justify-content: space-between;
}
.box{
    margin: 2px;
}
</style>

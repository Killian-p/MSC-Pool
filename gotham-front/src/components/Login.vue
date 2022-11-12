<template>
  <div class="mainbox">
    <div class="loginbox">
      <div class="tabbox">
        <button class="buttons" @click="changeTab('sign_in')" style="cursor:pointer">Connexion</button>
        <button class="buttons" @click="changeTab('sign_up')" style="cursor:pointer">Enregistrement</button>
      </div>
      <div class="formbox">
        <div class="labelInput">
          <label>Email:</label>
          <input v-model="email" />
        </div>
        <div v-if="currentTab == 'sign_up'">
          <div class="labelInput">
            <label>Username:</label>
            <input v-model="username" />
          </div>
        </div>
        <div class="labelInput">
          <label>Password:</label>
          <input v-model="password" type="password" />
        </div>
      </div>
      
      <span v-if="errorMessage" style="color: red">{{ errorMessage }}</span>
      <div style="display: flex">
        <div class="box" v-if="currentTab == 'sign_up'">
          <button @click="createUser" class="buttons" type="button" style="cursor:pointer">S'enregistrer</button>
        </div>
        <div class="box" v-if="currentTab == 'sign_in'">
          <button @click="login" class="buttons" type="button" style="cursor:pointer">Se connecter</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import sha256 from "crypto-js/sha256";
export default {
  components: {},
  props: {
    idUser: {
      type: Number,
    },
  },
  data() {
    return {
      connected: false,
      username: "",
      email: "",
      password: "",
      userExists: true,
      currentTab: "sign_in",
      errorMessage: "",
    };
  },
  mounted() {},
  created() {},
  computed: {},
  methods: {
    createUser() {
      axios
        .post(`${import.meta.env.VITE_BACKEND_URL}/api/users/sign_up`, {
          user: {
            username: this.username,
            email: this.email,
            password: sha256(this.password).toString(),
          },
        })
        .then((res) => {
          localStorage.setItem("token", res.data.token);
          this.$emit("logged", [res.data.id, res.data.roles]);
          this.$emit("username", res.data.username);
          this.userExists = true;
        })
        .catch((_) => {
          this.errorMessage = this.errorMessage = _.message ?? _.response.data.message;
        });
      this.connected = true;
    },
    login() {
      axios
        .post(`${import.meta.env.VITE_BACKEND_URL}/api/users/sign_in`, {
          password: sha256(this.password).toString(),
          email: this.email,
        })
        .then((_) => {
          localStorage.setItem("token", _.data.token);
          this.idCurrentUser = _.data.id;
          this.$emit("logged", [_.data.id, _.data.roles]);
          this.$emit("username", _.data.username);
          this.userExists = true;
        })
        .catch((_) => {
          this.errorMessage = _.message ?? _.response.data.message;
        });
    },
    changeTab(tab) {
      this.currentTab = tab;
    },
  },
  watch: {},
};
</script>

<style>
.mainbox {
  width: 90vw;
  height: 100%;
  justify-content: center;
  align-items: center;
  display: flex;
}

.loginbox {
  background-color: #00abb3;
  height: 50%;
  width: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 45px;
  flex-direction: column;
  border: black 3px solid;
  gap: 30px;
}

.label-column {
  display: flex;
  flex-direction: column;
  margin-right: 15px;
}

.input-column {
  display: flex;
  flex-direction: column;
}

.formbox {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.box {
  margin-top: 4px;
}

.buttons {
  border-radius: 20px;
  padding: 10px;
  /* width: 100%; */
  /* height: 150%; */
  background-color: #3c4048;
  color: #00abb3;
}

.buttons:hover {
  background-color: #00abb3;
  color: #3c4048;
}

.tabbox {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.tabnav {
  margin: 10px;
  border: black 3px solid;
  background-color: #3c4048;
  color: #00abb3;
}
.tabnav:hover {
  background-color: #00abb3;
  color: #3c4048;
}

.labelInput {
  display: flex;
  gap: 10px;
  justify-content: space-between;
}
</style>

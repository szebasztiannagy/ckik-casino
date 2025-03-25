<script setup lang="ts">
import type { title } from 'process';
import type { Value } from 'sass';
import { ref, computed, onMounted, watch, inject } from 'vue';

const betInput = ref(0);
const sideInput = ref<null | number>(null);
const isFlipping = ref(false);
const flipping = ref(false);
const result = ref('');
const showResult = ref(false);
const resultMessage = ref('');
const snackbarMessage = ref('');
const showSnackbar = ref(false);
const balance = inject('balance', ref(100000000));
const updateBalance = inject('updateBalance', (newBalance) => {
  console.log('Default updateBalance fallback called with:', newBalance);
});

console.log('Injected balance:', balance.value);

function showError(message: string) {
  snackbarMessage.value = message;
  showSnackbar.value = true;
}

const saveGameResult = async (isWin: boolean) => {
  try {
    const betAmount = Number(betInput.value);
    const pickedSide = Number(sideInput.value);
    const resultSide = Number(result.value);
    
    const token = localStorage.getItem('token');
    if (!token) {
      alert('Nincs bejelentkezve! Kérjük jelentkezzen be újra.');
      return;
    }
    
    const response = await axios.post('http://localhost:5000/api/games/play', {
      type: 'roulette',
      bet: betAmount,
      picked: pickedSide,
      result: resultSide,
    }, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    if (response.data && response.data.newBalance !== undefined) {
      updateBalance(response.data.newBalance);
    }
    
    if (isWin) {
      resultMessage.value = `Gratulálunk! Nyertél ${betAmount * 2} Ft-ot!`;
    } else {
      resultMessage.value = `Sajnos vesztettél ${betAmount} Ft-ot.`;
    }
    showResult.value = true;
    
    setTimeout(() => {
      showResult.value = false;
    }, 3000);
    
  } catch (error) {
    console.error('Hiba a játék eredményének mentésekor:', error);
    if (error.response && error.response.data && error.response.data.message) {
      alert(`Hiba: ${error.response.data.message}`);
    } else {
      alert('Hiba történt a játék során.');
    }
  }
};


const isButtonDisabled = computed(() => {

  const betAmount = Number(betInput.value);
  const side = sideInput.value;
  

  const currentBalance = Number(localStorage.getItem('balance'));
  

  if (betAmount > currentBalance) {
    showError('A tét összege nem lehet nagyobb, mint az egyenleg!');
    console.log("not good");
    return true;
  }
  

  return isFlipping.value || 
         sideInput.value === null || 
         betAmount <= 0;
});

const flipCoin = () => {
  if (flipping.value) return;
  isFlipping.value = true;
  flipping.value = true;
  result.value = '';
  showResult.value = false;

  const betAmount = Number(betInput.value);
  if (betAmount > balance.value) {
    alert('Nincs elegendő egyenleged a tét megtételéhez!');
    return;
  }

  setTimeout(() => {
    result.value = Math.random() < 0.5 ? 'heads' : 'tails';
    showResult.value = true;
  }, 5000);

  setTimeout(() => {
    flipping.value = false;
  }, 5000);


  
  setTimeout(() => {
    if (showResult.value) {
      emit('result', result.value);
    }
  }, 1000);

  const isWin = Number(value.name) === Number(sideInput.value);
  saveGameResult(isWin);
};

const emit = defineEmits<{
  (e: 'result', result: string): void;
}>();
</script>

<template>
  <v-snackbar v-model="showSnackbar" :timeout="3000" color="error">
      {{ snackbarMessage }}
    </v-snackbar>
  <v-container class="coin-container">
    <v-row>
      <v-col>
        <div>
    <div :class="['coin', flipping ? 'flipping' : '', result]">
      <div class="side heads">H</div>
      <div class="side tails">T</div>
    </div>
  </div>
  
  <h1 v-if="result" :class="['result-text', result]">
    {{ result === 'heads' ? 'Heads' : 'Tails' }}
  </h1>
      </v-col>
    </v-row>
    
  </v-container>
  
  <v-container width="300" class="bottom-container">
    <v-row>
      <v-col>
        <v-text-field 
        variant="solo"
          v-model="betInput" 
          type="number"
           min="1"
          
          suffix="Ft"
          placeholder="Enter your bet" 
          
        />
        
      

        <v-select
        variant="solo"
        v-model="sideInput"
        :items="[{title: 'Heads', value: 0},{title:'Tails', value:1}]" 
        placeholder="Choose Heads or Tails"
        density="comfortable"
/>

        
        <v-btn block :disabled="isButtonDisabled || sideInput == null || betInput <= 0"
        variant="flat" color="primary" @click="flipCoin()">
        
          
          Feldobás
        </v-btn>
      </v-col>
    </v-row>
    
   </v-container>

</template>




<style scoped>
.coin-container {
  margin-top: 20%;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100px;
  height: 100px;
  cursor: pointer;
}
.coin {
  width: 150px;
  height: 150px;
  position: relative;
  transform-style: preserve-3d;
  background-image: url(coin.png);
  background-size: cover;
  background-position: center;
  border-radius: 50%;
  transition: transform 1s;
}
.coin.flipping {
  animation: flip 5s cubic-bezier(0.3, 0.3, 0.3, 0.3);
}
.coin.heads {
  transform: rotateX(0deg);
}
.coin.tails {
  transform: rotateX(180deg);
}
.side {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30px;
  color: #424242;
  font-weight: bold;
  border-radius: 50%;
}
.side.tails {
  transform: rotateX(180deg);
}

@keyframes flip {
  0% {
    transform: rotateX(0deg);
  }
  100% {
    transform: rotateX(720deg);
  }
}

.result-text {
  font-size: 3em;
  text-align: center;
  margin-top: 20px;
  font-family: 'Arial', sans-serif;
  font-weight: bold;
  color: #f1c40f;
  position: relative;
  animation: fireEffect 1s ease forwards;
}

@keyframes fireEffect {
  0% {
    transform: scale(0);
    opacity: 0;
    text-shadow: 0 0 5px #e67e22, 0 0 10px #e67e22, 0 0 15px #e67e22;
  }
  50% {
    transform: scale(1.1);
    opacity: 1;
    text-shadow: 0 0 10px #e67e22, 0 0 20px #e67e22, 0 0 30px #e67e22;
  }
  100% {
    transform: scale(1);
    opacity: 1;
    text-shadow: 0 0 20px #f39c12, 0 0 30px #f39c12, 0 0 50px #f39c12, 0 0 60px #f39c12;
  }
}

@keyframes bounce {
  0% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-10px);
  }
  50% {
    transform: translateY(5px);
  }
  70% {
    transform: translateY(-5px);
  }
  100% {
    transform: translateY(0);
  }
}

.bottom-container {
  width: 100%;
  max-width: 400px;
  padding: 20px;
  text-align: center;
  margin-bottom: 15vh;
  margin-top: 50px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}


</style>

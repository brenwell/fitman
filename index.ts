import { exec } from 'child_process'

const standard_input = process.stdin;

let isRunning = true
standard_input.on('data', function (data) {
  if(isRunning) { 
    pause()
  }else{
    resume()
  }
  isRunning = !isRunning
});

const DELAY_BEFORE = 5
const DELAY_AFTER = 2

type Exc = {
  label: string,
  duration: number
}

const EXCERSICES: Exc[] = [
  // { label: `Door jam`, duration: 60 },
  // { label: `Wall stand`, duration: 60 },
  { label: `Door stretch`, duration: 20 },
  { label: `Wall stand`, duration: 60 },
  { label: `Door jam`, duration: 60 },
  { label: `Wall stand`, duration: 60 },
  { label: `Touch toes`, duration: 40 },
  { label: `Wall sit`, duration: 40 },
  { label: `Tricep dips`, duration: 40 },
  { label: `Lunges`, duration: 40 },
  { label: `Push-ups`, duration: 40 },
  { label: `Crunches`, duration: 40 },
  { label: `Reverse plank`, duration: 40 },
  { label: `Crouching dog`, duration: 40 },
  //{ label: `Hand walkouts`, duration: 40 },
  { label: `Calf raises`, duration: 40 },
  { label: `Hand to wall`, duration: 40 },
  { label: `Plank`, duration: 40 },
  { label: `T-raises`, duration: 40 },
  { label: `Butt lift`, duration: 40 },
  { label: `Push-ups`, duration: 40 },
  { label: `Arm circles`, duration: 40 },
  { label: `Touch toes`, duration: 40 },
]


async function main(excersices: Exc[], before: number, after: number) {
  await asyncForEach(excersices, async (e: Exc, i: Number) => {
    await countDown(e, before)
    await excersice(e) 
    await delay(after)
  })
  say(`Finished`)
}

function excersice(e: Exc, lapsed: number = 0) {
  return new Promise( async resolve => {
    excersiceTick(e, resolve, 0)
    
  })
}

function excersiceTick(e: Exc, resolve: Function, lapsed: number ) {

    lapsed += 1
    
    console.log(`${e.label} ${lapsed} / ${e.duration}`)
    
    if (lapsed === 1) {
      soundStart()
    }

    else if ( lapsed >= e.duration ) {
      soundEnd()
      return resolve()
    }

    else if ( lapsed + 4 > e.duration && lapsed <= e.duration) {
      soundTick()
    }

    else if (lapsed % 10 === 0) {
      say(`${lapsed}`)
    }  
  
    tick(() => excersiceTick(e, resolve, lapsed))
}


function countDown(e: Exc, duration: number,lapsed: number = 0) {
  return new Promise( async resolve => {
    countTick(e, duration, resolve, 0)
    
  })
}

function countTick(e: Exc, duration: number, resolve: Function, lapsed: number ) {
    
  if (lapsed === 0) {
    say(`${e.label} for ${e.duration} seconds`)
  }

  if ( lapsed + 3 > duration ) {
    soundTick()
  }

  if ( lapsed > duration ) {
    // soundEnd()
    return resolve()
  }

  lapsed += 1

  console.log(`${e.label} Starting`)

  tick(() => countTick(e, duration, resolve, lapsed))
}


function delay(duration: number,lapsed: number = 0) {
  return new Promise( async resolve => {
    delayTick(duration, resolve, 0)
    
  })
}

function delayTick(duration: number, resolve: Function, lapsed: number ) {
    
  if ( lapsed >= duration ) {
    return resolve()
  }

  lapsed += 1

  tick(() => delayTick(duration, resolve, lapsed))
}

let timer
let step

function tick(fn) {
  step = fn
  timer = setTimeout( () => {
    timer = null
    fn()
  } , 1000)
}

function pause() {
  console.log(`pausing`)
  say(`pausing`)
  clearTimeout(timer)
  timer = null
}

function resume() {
  console.log(`resuming`)
  say(`resuming`)
  tick(step)
}

function say(msg: String) {
  exec(`say -v Daniel "${msg}"`)
}

function soundTick() {
  sound(`Pop`, 5)
}

function soundEnd() {
  sound(`Purr`, 5)
}

function soundStart() {
  sound(`Tink`, 5)
}

function sound(s, v=5) {
  exec(`afplay /System/Library/Sounds/${s}.aiff -v ${v}`)
}

async function asyncForEach(array: any[], callback: Function) {
  for (let index = 0; index < array.length; index++) {
    await callback(array[index], index, array);
  }
}

main(EXCERSICES, DELAY_BEFORE, DELAY_AFTER)
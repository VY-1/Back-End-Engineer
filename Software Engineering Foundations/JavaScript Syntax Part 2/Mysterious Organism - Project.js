/*
Challenge Project: Mysterious Organism
Overview
This project is slightly different than others you have encountered thus far on Codecademy. Instead of a step-by-step tutorial, this project contains a series of open-ended requirements which describe the project you’ll be building. There are many possible ways to correctly fulfill all of these requirements, and you should expect to use the internet, Codecademy, and other resources when you encounter a problem that you cannot easily solve.

Project Goals
Context: You’re part of a research team that has found a new mysterious organism at the bottom of the ocean near hydrothermal vents. Your team names the organism, Pila aequor (P. aequor), and finds that it is only comprised of 15 DNA bases. The small DNA samples and frequency at which it mutates due to the hydrothermal vents make P. aequor an interesting specimen to study. However, P. aequor cannot survive above sea level and locating P. aequor in the deep sea is difficult and expensive. Your job is to create objects that simulate the DNA of P. aequor for your research team to study.

As you progress through the steps, use the terminal and console.log() statements to check the output of your loops and functions.
*/


// Returns a random DNA base
const returnRandBase = () => {
    const dnaBases = ['A', 'T', 'C', 'G']
    return dnaBases[Math.floor(Math.random() * 4)] 
}
  
  // Returns a random single strand of DNA containing 15 bases
const mockUpStrand = () => {
    const newStrand = []
    for (let i = 0; i < 15; i++) {
      newStrand.push(returnRandBase())
    }
    return newStrand
}
  
/*
2.
Look over the starter code. There are two helper functions: returnRandBase() and mockUpStrand().

DNA is comprised of four bases (Adenine, Thymine, Cytosine, and Guanine). When returnRandBase() is called, it will randomly select a base and return the base ('A','T','C', or 'G').

mockUpStrand() is used to generate an array containing 15 bases to represent a single DNA strand with 15 bases.

You’ll use these helper functions later to create your objects that represent P. aequor.

3.
Since you need to create multiple objects, create a factory function pAequorFactory() that has two parameters:

The first parameter is a number (no two organisms should have the same number).
The second parameter is an array of 15 DNA bases.
pAequorFactory() should return an object that contains the properties specimenNum and dna that correspond to the parameters provided.

You’ll also add more methods to this returned object in the later steps.

4.
Your team wants you to simulate P. aequor‘s high rate of mutation (change in its DNA).

To simulate a mutation, in pAequorFactory()‘s returned object, add the method .mutate().

.mutate() is responsible for randomly selecting a base in the object’s dna property and changing the current base to a different base. Then .mutate() will return the object’s dna.

For example, if the randomly selected base is the 1st base and it is 'A', the base must be changed to 'T', 'C', or 'G'. But it cannot be 'A' again.

5.
Your research team wants to be able to compare the DNA sequences of different P. aequor. You’ll have to add a new method (.compareDNA()) to the returned object of the factory function.

.compareDNA() has one parameter, another pAequor object.

The behavior of .compareDNA() is to compare the current pAequor‘s .dna with the passed in pAequor‘s .dna and compute how many bases are identical and in the same locations. .compareDNA() does not return anything, but prints a message that states the percentage of DNA the two objects have in common — use the .specimenNum to identify which pAequor objects are being compared.

For example:

ex1 = ['A', 'C', 'T', 'G']
ex2 = ['C', 'A', 'T', 'T']

ex1 and ex2 only have the 3rd element in common ('T') and therefore, have 25% (1/4) of their DNA in common. The resulting message would read something along the lines of: specimen #1 and specimen #2 have 25% DNA in common.

6.
P. aequor have a likelier chance of survival if their DNA is made up of at least 60% 'C' or 'G' bases.

In the returned object of pAequorFactory(), add another method .willLikelySurvive().

.willLikelySurvive() returns true if the object’s .dna array contains at least 60% 'C' or 'G' bases. Otherwise, .willLikelySurvive() returns false.

7.
With the factory function set up, your team requests that you create 30 instances of pAequor that can survive in their natural environment. Store these instances in an array for your team to study later.
*/

const pAequorFactory = (specimenNum, dna) =>{

    return {
        specimenNum,
        dna,
        mutate () {
            //randomly select dna Base index to mutate
            let ranDnaIndex = Math.floor(Math.random() * this.dna.length);
            let newBase = returnRandBase();
            //if the selected dna base index is the same as random selected base, random select base again. It cannot be the same as the
            //original dna's base.
            while(this.dna[ranDnaIndex] === newBase){
                newBase = returnRandBase();
            }
            //set the dna base at index to newBase; Mutate the current' base and return
            this.dna[ranDnaIndex] = newBase;
            return this.dna;

        },
        compareDNA (other_pAequor) {
            let identicalCount = 0;
            let percentage = 0;
            for (let i = 0; i < this.dna.length-1; i++){
                if (this.dna[i] === other_pAequor.dna[i]){
                    identicalCount ++;
                }
            }
            percentage = (identicalCount/this.dna.length) * 100;
            console.log(`specimen #${this.specimenNum} and specimen #${other_pAequor.specimenNum} have ${percentage.toFixed()}% DNA in common.`);
        },
        willLikelySurvive () {
            const CorG = this.dna.filter(baseDna => baseDna === "C" || baseDna === "G");
            //return true if CorG is 60% or more
            return CorG.length/this.dna.length >= 0.6;
        }

    }
  
};

const survivingSpecimen = [];
let idCounter = 1;

while(survivingSpecimen.length <= 30){
    let newOrg = pAequorFactory(idCounter, mockUpStrand());
    if (newOrg.willLikelySurvive()) {
        survivingSpecimen.push(newOrg);

    }
    idCounter ++;

}
  
//Test
let pAequor1 = pAequorFactory(1, mockUpStrand());
let pAequor2 = pAequorFactory(4, mockUpStrand());


console.log(pAequor1);
console.log(pAequor2);
/*
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor.mutate());
console.log(pAequor2.mutate());
*/

pAequor1.compareDNA(pAequor2);
  
survivingSpecimen.forEach(surviveSpec => {
    console.log("Surviving Spec #: " + surviveSpec.specimenNum);
});


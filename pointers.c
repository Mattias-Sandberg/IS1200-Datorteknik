#include <stdio.h>

char* text1 = "This is a string.";
char* text2 = "Yet another thing.";

// Array storleken är 20 eftersom Mips.ams specifierar 80 bytes av minne och int har 4 byte (80/4 = 20)
int  list1[20];  // Deklareras som int för att kunna använda hexadecimal
int  list2[20];  // Printlist anropar också på en int
int  count = 0; // Defineras i minnet som global counter

//roppar på text som char och list och count som int
void copycodes(char* text, int* list, int* count)
{
  // Hänvisar pekaren till text för att för att få värdet vid pekaren att kolla om det har nått NUL
  // i assambley: beq eq	$t0,$0,done
  while(*text != 0){

    // Hänvisar och copierar värdet från text till list
    // i assambley : (lb	$t0,0($a0)) & (sw	$t0,0($a1))
    *list = *text;

    // Utökar värdet hoss pekarna med 1
    // I assambley: (addi	$a0,$a0,1) & (addi $a1,$a1,4)
    text += 1;
    list += 1;

    // Ordningen hoss operationerna för hänvisning och Utökningen är samma därför sätts count i paranteser, sedan count++
    // I assambley: addi	$t1,$t1,1	# Increase the count
    (*count)++;
  }
}

void work(){

  // Skickar Arrays som parameter till pekare för första element, Count skrivs som adress
  // jal copycodes($a0, $a1, $a2);
  copycodes(text1, list1, &count);

  // Skickar Arrays som parameter till pekare för första element, Count skrivs som adress
  // jal copycodes($a0, $a1, $a2);
  copycodes(text2, list2, &count);

}

void printlist(const int* lst){
  printf("ASCII codes and corresponding characters.\n");
  while(*lst != 0){
    printf("0x%03X '%c' ", *lst, (char)*lst);
    lst++;
  }
  printf("\n");
}

void endian_proof(const char* c){
  printf("\nEndian experiment: 0x%02x,0x%02x,0x%02x,0x%02x\n",
         (int)*c,(int)*(c+1), (int)*(c+2), (int)*(c+3));

}

int main(void){
  work();

  printf("\nlist1: ");
  printlist(list1);
  printf("\nlist2: ");
  printlist(list2);
  printf("\nCount = %d\n", count);

  endian_proof((char*) &count);
}

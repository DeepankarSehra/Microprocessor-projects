#include <at89c5131.h>
#include "endsem.h"

char S_str[6]= {0,0,0,0,0,0};   //String for Balance Sita
char G_str[6] = {0,0,0,0,0,0};  //String for Balance Gita
char n500_s[3]= {0,0,0};    // STRING FOR 500RS NOTE
char n100_s[3]= {0,0,0};    // STRING FOR 100RS NOTE

char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY
//Main function

void haha1(char cq)
									{
										if(cq == 1)
										{ 
											transmit_string("Account Holder: Sita \r\n");
											transmit_string("Account Balance: 10000 \r\n");
										}
										else if(cq == 2)
										{
											transmit_string("Account Holder: Gita \r\n");
											transmit_string("Account Balance: 10000 \r\n");
										}
										else 
										{
											transmit_string("No such account, please enter valid details\r\n");
										}
									}

void haha2(char cq1)
									{
										if(cq1 == 1)
										{ 
											transmit_string("Account Holder: Sita \r\n");
											transmit_string("Account Balance: 10000 \r\n");
										}
										else if(cq1 == 2)
										{
											transmit_string("Account Holder: Gita \r\n");
											transmit_string("Account Balance: 10000 \r\n");
										}
										else 
										{
											transmit_string("No such account, please enter valid details\r\n");
										}
									}
									

									
void denomination(unsigned char x, unsigned char y)
{
	int number500 = 0;
	int number100 = 0;
	int balance =0;
	x = 10*x;
	number500 = (x/5)+(y/5);
	number100 = y%5;
	balance = 10000 - (x*1000) - (y*100);
	int_to_string(balance, S_str);
	transmit_string("Remaining Balance: ");
	transmit_string(S_str);
	transmit_string("500 Notes: ");
	int_to_string_2(number500, n500_s);
	transmit_string(n500_s);
	transmit_string(", 100 Notes: ");
	int_to_string_2(number100, n100_s);
	transmit_string(n100_s);
}


//-------------------------------------------------
void main(void)
{
	unsigned char pass1[5] = {0,0,0,0,0};
	unsigned char pass2[5] = {0,0,0,0,0};
	unsigned char ch = 0;
	unsigned char ch1 = 0;
	unsigned char ch2 = 0;
	unsigned char num1 = 0;
	unsigned char num2 = 0;
	uart_init();            // Please finish this function in endsem.h 
	
	transmit_string("press A for Account display and W for withdrawing cash\r\n");
    while (1)
    {
			ch = receive_char();	
			switch(ch)
			{
				case 'a': transmit_string("Hello, please enter account number\r\n");
									ch1 = receive_char();
									haha1(ch1);
				
				case 'w': transmit_string("Withdraw state, enter account number\r\n");
									ch2 = receive_char();
									haha2(ch2);
									if(ch2 == 1)
									{
										transmit_string("Please enter password: ");
										pass1 = receive_char();
										if(pass1 == "EE337")
										{
											transmit_string("Enter amount, in hundreds");
											num1 = receive_char();
											num2 = receive_char();
											denomination(num1, num2);	
										}
										else
										{
											transmit_string("wrong password");
										}
										
									}
									if(ch2 == 2)
									{
										transmit_string("Please enter password: ");
										pass2 = receive_char();
										if(pass2 == "UPLAB")
										{
											transmit_string("Enter amount, in hundreds");
											num1 = receive_char();
											num2 = receive_char();
											denomination(num1, num2);	
										}
										else
										{
											transmit_string("wrong password");
										}
										transmit_string("Enter amount, in hundreds");
										num1 = receive_char();
										num2 = receive_char();
										denomination(num1, num2);
										
									}
									
			}	
        /* code */
        // YOUR CODE GOES HERE
    }
}



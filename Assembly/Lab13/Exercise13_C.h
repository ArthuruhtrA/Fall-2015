/*********************************************************************/
/* Lab Exercise Thirteen                                             */
/* Name:  R. W. Melton                                               */
/* Date:  November 16, 2015                                          */
/* Class:  CMPE 250                                                  */
/* Section:  All sections                                            */
/*********************************************************************/
typedef int Int32;
typedef short int Int16;
typedef char Int8;
typedef unsigned int UInt32;
typedef unsigned short int UInt16;
typedef unsigned char UInt8;

/* assembly language subroutines */
char GetChar (void);
void GetStringSB (char String[], int StringBufferCapacity);
void Init_UART0_IRQ (void);
void PutChar (char Character);
void PutNumHex (UInt32);
void PutNumUB (UInt8);
void PutStringSB (char String[], int StringBufferCapacity);
void PutCRLF (void);
void Init_PIT_IRQ (void);
void Init_LED (void);
void LED (int Color, int Toggle);

extern int		Count;
extern int		RunTimer;
extern char		RxQRecord;

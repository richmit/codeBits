
#include "mainly.h"
#include "usart.h"
#include "main.h"

void swoInit (uint32_t portMask, uint32_t prescaler) { 
	CoreDebug->DEMCR = CoreDebug_DEMCR_TRCENA_Msk; // CoreDebug Debug Exception and Monitor Control Register .. Enables access to registers
    DBGMCU->CR       = 0x00000027u;                // Debug MCU: Configuration Register
	TPI->SPPR        = 0x00000002u;                // TPI Selected PIN Protocol Register .. 2 = NRZ/USART
	TPI->ACPR        = prescaler;   			   // TPI Async Clock Prescaler Register
	ITM->LAR         = 0xC5ACCE55u;                // ITM Lock Access Register
	ITM->TCR         = 0x0001000Du;                // ITM Trace Control Register
	ITM->TPR         = ITM_TPR_PRIVMASK_Msk;	   // ITM Trace Privilege Register
	ITM->TER         = portMask;				   // ITM Trace Enable Register
	DWT->CTRL        = 0x400003FEu;                // DWT Control Register
	TPI->FFCR        = 0x00000100u;                // TPI Formatter and Flush Control Register .. 0x200 = ETM framing enabled, 0x100 = Just DWT/ITM
}

int mainly(void) {

  const int mlen = 20;
  char msg_swo[mlen] = "SWO: Hello, World!\n";
  char msg_nrz[mlen] = "NRZ: Hello, World!\n";
//  char msg_rtt[mlen] = "RTT: Hello, World!\n";
//  char msg_hst[mlen] = "HST: Hello, World!\n";

  // if constexpr (O_DEBUG)
  //   swoInit(0x1, 170000000, 170);

  while(1) {

    if constexpr (O_DEBUG)
      for(int i=0; i<mlen-1; i++) 
        ITM_SendChar(msg_swo[i]);

    if constexpr (O_DEBUG)
      HAL_UART_Transmit(&UART_VCP, (const uint8_t*)msg_nrz, mlen-1, 1000);

    if constexpr (O_DEBUG)
      HAL_GPIO_TogglePin (LED_GPIO_Port, LED_Pin);

    HAL_Delay (500);

  }

  return 0;
}
  



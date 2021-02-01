/*
 * Copyright 2016-2021, Cypress Semiconductor Corporation (an Infineon company) or
 * an affiliate of Cypress Semiconductor Corporation.  All rights reserved.
 *
 * This software, including source code, documentation and related
 * materials ("Software") is owned by Cypress Semiconductor Corporation
 * or one of its affiliates ("Cypress") and is protected by and subject to
 * worldwide patent protection (United States and foreign),
 * United States copyright laws and international treaty provisions.
 * Therefore, you may use this Software only as provided in the license
 * agreement accompanying the software package from which you
 * obtained this Software ("EULA").
 * If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
 * non-transferable license to copy, modify, and compile the Software
 * source code solely for use in connection with Cypress's
 * integrated circuit products.  Any reproduction, modification, translation,
 * compilation, or representation of this Software except as specified
 * above is prohibited without the express written permission of Cypress.
 *
 * Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
 * reserves the right to make changes to the Software without notice. Cypress
 * does not assume any liability arising out of the application or use of the
 * Software or any product or circuit described in the Software. Cypress does
 * not authorize its products for use in any products where a malfunction or
 * failure of the Cypress product may reasonably be expected to result in
 * significant property damage, injury or death ("High Risk Product"). By
 * including Cypress's product in a High Risk Product, the manufacturer
 * of such system or application assumes all risk of such use and in doing
 * so agrees to indemnify Cypress against all liability.
 */

/** @file
*
* Defines peripherals available for use on CYW943012BTEVK-01
*
*/

#pragma once

/** \addtogroup Platfrom config - Peripherals pin configuration
*   \ingroup HardwareDrivers
*/
/*! @{ */

/******************************************************
 *                   Enumerations
 ******************************************************/

#include "wiced_bt_types.h"
#include "wiced_hal_gpio.h"
#include "wiced_bt_trace.h"

typedef enum
{
    WICED_PLATFORM_PTU_SEL_USB         = 0x01,
    WICED_PLATFORM_PTU_SEL_UART        = 0x02,
    WICED_PLATFORM_PTU_SEL_I2C_SLAVE   = 0x04,
    WICED_PLATFORM_PTU_SEL_SPIFFY      = 0x20,
    WICED_PLATFORM_PTU_SEL_UNKNOWN     = 0xff
} wiced_platform_ptu_sel_t;

//! Number of Buttons available on the platform.
typedef enum
{
    WICED_PLATFORM_BUTTON_1,  //!< BUTTON 1
    WICED_PLATFORM_BUTTON_2,  //!< BUTTON 2
    WICED_PLATFORM_BUTTON_3,  //!< BUTTON 3
    WICED_PLATFORM_BUTTON_4,  //!< BUTTON 4
    WICED_PLATFORM_BUTTON_MAX //!< Max button for error check
} wiced_platform_button_number_t;

#define WICED_PLATFORM_BUTTON_MAX_DEF     4   //define for preprocessor

#define HCI_UART_DEFAULT_BAUD   3000000   /* default baud rate is 3M, that is max supported baud rate on Mac OS */

/* In fact, in cyw9b5_audio library, these settings are just for compile, no actual functionality */
#define SPI_CS      WICED_P00
#define SPI_CLK     WICED_P11
#define SPI_MOSI    WICED_P01
#define SPI_MISO    WICED_P09
#define I2S_DI      WICED_P04
#define I2S_DO      WICED_P06
#define I2S_WS      WICED_GPIO_09       // BT_PCM_SYNC, A_GPIO[1]
#define I2S_CLK     WICED_GPIO_08       // BT_PCM_CLK, A_GPIO[0]
#define WICED_RESET_PIN     WICED_P34

#define WICED_BUTTON1 (WICED_GPIO_03)
#define WICED_BUTTON2 (WICED_P07)
#define WICED_BUTTON3 (WICED_P13)
#define WICED_BUTTON4 (WICED_GPIO_10)

#define WICED_GPIO_BUTTON_SETTINGS(x)                       ( GPIO_INPUT_ENABLE | GPIO_PULL_UP | x )

/**
 * as a flag to present bt transport opened or not
 * 0: not open; others: open
 */
extern uint8_t platform_transport_started;

/**
 * wiced_platform_transport_rx_data_handler
 *
 * Callback registered by the application to receive the incoming HCI UART data.
 *
 * @param[in] op_code   : operation code for the incoming HCI data (refer to hci_control_api.h)
 * @param[in] p_data    : Pointer to the received data for the op_code
 * @param[in] data_len  : length of the data pointed to by p_data in bytes
 */
typedef void (wiced_platform_transport_rx_data_handler)(uint16_t op_code, uint8_t *p_data, uint32_t data_len);

/**
 * debug_uart_enable
 *
 * Initialize debug uart and set baud rate.
 *
 * @param[in] baud_rate : the speed of debug messsage
 */
void debug_uart_enable(uint32_t baud_rate);

/**
 * wiced_platform_init
 *
 * Initialize the platform-specific peripheral interface settings
 */
void wiced_platform_init(void);

/**
 * wiced_platform_i2s_init
 *
 * Initialize the I2S interface.
 */
void wiced_platform_i2s_init(void);

/**
 * wiced_platform_spi_init
 *
 * Initialize the SPI interface.
 */
void wiced_platform_spi_init(void);

/**
 * wiced_platform_spi_init
 *
 * Initialize the SPI interface.
 */
void wiced_platform_i2c_init(void);

/**
 * wiced_platform_transport_init
 *
 * Initialize the WICED HCI Transport interface.
 *
 * @param[in] p_rx_data_handler : user callback for incoming HCI data.
 *
 * @return  WICED_TRUE - success
 *          WICED_FALSE - fail
 */
wiced_bool_t wiced_platform_transport_init(wiced_platform_transport_rx_data_handler *p_rx_data_handler);

/**
 * wiced_platform_set_ptu_fifo
 *
 * Select the source of PTU FIFO, before using spiffy, uart, or usb.
 */
void wiced_platform_set_ptu_fifo(wiced_platform_ptu_sel_t sel);

/**
 * wiced_platform_get_ptu_fifo
 *
 * Get the current source of PTU FIFO
 */
wiced_platform_ptu_sel_t wiced_platform_get_ptu_fifo(void);

extern wiced_debug_uart_types_t wiced_debug_uart;

/* @} */

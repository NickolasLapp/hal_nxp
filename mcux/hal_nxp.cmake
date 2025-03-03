list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/devices/${MCUX_DEVICE}
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/devices/${MCUX_DEVICE}/drivers
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/common
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/dmamux
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/CMSIS/Core/Include
)

function(include_ifdef feature_toggle module)
  if(${${feature_toggle}})
    include(${module})
  endif()
endfunction()

function(include_driver_ifdef feature_toggle directory module)
  if(${${feature_toggle}})
    list(APPEND CMAKE_MODULE_PATH
        ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/${directory}
    )
    zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/${directory})
    include(${module})
  endif()
endfunction()

message("Load components for ${MCUX_DEVICE}:")

#specific operation to shared drivers
if(CONFIG_FLASH_MCUX_FLEXSPI_XIP)
  zephyr_code_relocate(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/flexspi/fsl_flexspi.c ${CONFIG_FLASH_MCUX_FLEXSPI_XIP_MEM}_TEXT)
endif()

if(NOT CONFIG_ASSERT OR CONFIG_FORCE_NO_ASSERT)
  zephyr_compile_definitions(NDEBUG) # squelch fsl_flexcan.c warning
endif()

zephyr_compile_definitions_ifdef(
  CONFIG_PTP_CLOCK_MCUX
  ENET_ENHANCEDBUFFERDESCRIPTOR_MODE
)

zephyr_library_compile_definitions_ifdef(
  CONFIG_HAS_MCUX_CACHE FSL_SDK_ENABLE_DRIVER_CACHE_CONTROL
)

include(driver_common)

#Include system_xxx file for MXRT platforms
#This can be extended to other SoC series if needed
if (CONFIG_SOC_MIMXRT1166_CM4)
include(device_system_MIMXRT1166_cm4)
elseif (CONFIG_SOC_MIMXRT1166_CM7)
include(device_system_MIMXRT1166_cm7)
elseif (CONFIG_SOC_MIMXRT1176_CM4)
include(device_system_MIMXRT1176_cm4)
elseif (CONFIG_SOC_MIMXRT1176_CM7)
include(device_system_MIMXRT1176_cm7)
elseif (CONFIG_SOC_SERIES_IMX_RT OR CONFIG_SOC_SERIES_IMX_RT6XX OR CONFIG_SOC_SERIES_IMX_RT5XX)
include(device_system)
endif()

zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/common)

#include shared drivers
include_driver_ifdef(CONFIG_ADC_MCUX_LPADC		lpadc		driver_lpadc)
include_driver_ifdef(CONFIG_COUNTER_MCUX_CTIMER		ctimer		driver_ctimer)
include_driver_ifdef(CONFIG_COUNTER_MCUX_LPC_RTC	lpc_rtc		driver_lpc_rtc)
include_driver_ifdef(CONFIG_DMA_MCUX_LPC		lpc_dma		driver_lpc_dma)
include_driver_ifdef(CONFIG_GPIO_MCUX_LPC		lpc_gpio        driver_lpc_gpio)
include_driver_ifdef(CONFIG_GPIO_MCUX_LPC		pint    	driver_pint)
include_driver_ifdef(CONFIG_GPIO_MCUX_LPC		inputmux	driver_inputmux)
include_driver_ifdef(CONFIG_I2C_MCUX_FLEXCOMM		flexcomm	driver_flexcomm_i2c)
include_driver_ifdef(CONFIG_I2C_MCUX_FLEXCOMM		flexcomm	driver_flexcomm)
include_driver_ifdef(CONFIG_I2S_MCUX_FLEXCOMM		flexcomm	driver_flexcomm_i2s)
include_driver_ifdef(CONFIG_I2S_MCUX_FLEXCOMM		flexcomm	driver_flexcomm)
include_driver_ifdef(CONFIG_MCUX_OS_TIMER		ostimer		driver_ostimer)
include_driver_ifdef(CONFIG_PWM_MCUX_SCTIMER		sctimer		driver_sctimer)
include_driver_ifdef(CONFIG_SOC_FLASH_LPC		flashiap	driver_flashiap)
include_driver_ifdef(CONFIG_SPI_MCUX_FLEXCOMM		flexcomm	driver_flexcomm_spi)
include_driver_ifdef(CONFIG_SPI_MCUX_FLEXCOMM		flexcomm	driver_flexcomm)
include_driver_ifdef(CONFIG_UART_MCUX_FLEXCOMM		flexcomm	driver_flexcomm_usart)
include_driver_ifdef(CONFIG_UART_MCUX_FLEXCOMM		flexcomm	driver_flexcomm)
include_driver_ifdef(CONFIG_WDT_MCUX_WWDT		wwdt		driver_wwdt)
include_driver_ifdef(CONFIG_ADC_MCUX_ADC12		adc12		driver_adc12)
include_driver_ifdef(CONFIG_ADC_MCUX_ADC16		adc16		driver_adc16)
include_driver_ifdef(CONFIG_IPM_IMX_REV2		mu		driver_mu)
include_driver_ifdef(CONFIG_CAN_MCUX_FLEXCAN		flexcan		driver_flexcan)
include_driver_ifdef(CONFIG_COUNTER_MCUX_PIT		pit		driver_pit)
include_driver_ifdef(CONFIG_COUNTER_MCUX_RTC		rtc		driver_rtc)
include_driver_ifdef(CONFIG_DAC_MCUX_DAC		dac		driver_dac)
include_driver_ifdef(CONFIG_DAC_MCUX_DAC32		dac32		driver_dac32)
include_driver_ifdef(CONFIG_DMA_MCUX_EDMA		edma		driver_edma)
include_driver_ifdef(CONFIG_DMA_MCUX_EDMA		dmamux		driver_dmamux)
include_driver_ifdef(CONFIG_ENTROPY_MCUX_RNGA		rnga		driver_rnga)
include_driver_ifdef(CONFIG_ENTROPY_MCUX_TRNG		trng		driver_trng)
include_driver_ifdef(CONFIG_ETH_MCUX			enet		driver_enet)
include_driver_ifdef(CONFIG_HAS_MCUX_SMC		smc		driver_smc)
include_driver_ifdef(CONFIG_I2C_MCUX			i2c		driver_i2c)
include_driver_ifdef(CONFIG_I2C_MCUX_LPI2C		lpi2c		driver_lpi2c)
include_driver_ifdef(CONFIG_MCUX_ACMP			acmp		driver_acmp)
include_driver_ifdef(CONFIG_PWM_MCUX_FTM		ftm     	driver_ftm)
include_driver_ifdef(CONFIG_PWM_MCUX_TPM		tpm		driver_tpm)
include_driver_ifdef(CONFIG_PWM_MCUX_PWT		pwt		driver_pwt)
include_driver_ifdef(CONFIG_RTC_MCUX			rtc		driver_rtc)
include_driver_ifdef(CONFIG_SPI_MCUX_DSPI		dspi		driver_dspi)
include_driver_ifdef(CONFIG_SPI_MCUX_LPSPI		lpspi		driver_lpspi)
include_driver_ifdef(CONFIG_UART_MCUX			uart		driver_uart)
include_driver_ifdef(CONFIG_UART_MCUX_LPSCI		lpsci		driver_lpsci)
include_driver_ifdef(CONFIG_UART_MCUX_LPUART		lpuart		driver_lpuart)
include_driver_ifdef(CONFIG_WDT_MCUX_WDOG		wdog		driver_wdog)
include_driver_ifdef(CONFIG_WDT_MCUX_WDOG32		wdog32		driver_wdog32)
include_driver_ifdef(CONFIG_COUNTER_MCUX_GPT		gpt		driver_gpt)
include_driver_ifdef(CONFIG_MCUX_GPT_TIMER		gpt		driver_gpt)
include_driver_ifdef(CONFIG_COUNTER_MCUX_PIT		pit		driver_pit)
include_driver_ifdef(CONFIG_DISPLAY_MCUX_ELCDIF		elcdif		driver_elcdif)
include_driver_ifdef(CONFIG_ETH_MCUX			enet		driver_enet)
include_driver_ifdef(CONFIG_GPIO_MCUX_IGPIO		igpio		driver_igpio)
include_driver_ifdef(CONFIG_I2C_MCUX_LPI2C		lpi2c		driver_lpi2c)
include_driver_ifdef(CONFIG_I2S_MCUX_SAI		sai		driver_sai)
include_driver_ifdef(CONFIG_MEMC_MCUX_FLEXSPI		flexspi		driver_flexspi)
include_driver_ifdef(CONFIG_PWM_MCUX			pwm		driver_pwm)
include_driver_ifdef(CONFIG_SPI_MCUX_LPSPI		lpspi		driver_lpspi)
include_driver_ifdef(CONFIG_UART_MCUX_LPUART		lpuart		driver_lpuart)
include_driver_ifdef(CONFIG_VIDEO_MCUX_CSI		csi		driver_csi)
include_driver_ifdef(CONFIG_WDT_MCUX_IMX_WDOG		wdog01		driver_wdog01)
include_driver_ifdef(CONFIG_DMA_MCUX_LPC		lpc_dma		driver_lpc_dma)
include_driver_ifdef(CONFIG_MEMC_MCUX_FLEXSPI		flexspi		driver_flexspi)
include_driver_ifdef(CONFIG_HAS_MCUX_RDC		rdc		driver_rdc)
include_driver_ifdef(CONFIG_UART_MCUX_IUART		iuart		driver_iuart)
include_driver_ifdef(CONFIG_ADC_MCUX_12B1MSPS_SAR	adc_12b1msps_sar	driver_adc_12b1msps_sar)
include_driver_ifdef(CONFIG_HWINFO_MCUX_SRC		src		driver_src)
include_driver_ifdef(CONFIG_HWINFO_MCUX_SIM		sim		driver_sim)
include_driver_ifdef(CONFIG_HWINFO_MCUX_RCM		rcm		driver_rcm)
include_driver_ifdef(CONFIG_IPM_MCUX			mailbox		driver_mailbox)
include_driver_ifdef(CONFIG_COUNTER_MCUX_SNVS		snvs_hp		driver_snvs_hp)
include_driver_ifdef(CONFIG_COUNTER_MCUX_SNVS_SRTC	snvs_lp		driver_snvs_lp)
include_driver_ifdef(CONFIG_COUNTER_MCUX_LPTMR		lptmr		driver_lptmr)
include_driver_ifdef(CONFIG_MCUX_LPTMR_TIMER		lptmr		driver_lptmr)
include_driver_ifdef(CONFIG_IMX_USDHC			usdhc		driver_usdhc)
include_driver_ifdef(CONFIG_MIPI_DSI_MCUX		mipi_dsi_split	driver_mipi_dsi_split)
include_driver_ifdef(CONFIG_ADC_LPC_ADC			lpc_adc		driver_lpc_adc)

if ((${MCUX_DEVICE} MATCHES "MIMXRT1[0-9][0-9][0-9]") AND (NOT (CONFIG_SOC_MIMXRT1166_CM4 OR CONFIG_SOC_MIMXRT1176_CM4)))
  include_driver_ifdef(CONFIG_HAS_MCUX_CACHE		cache/armv7-m7	driver_cache_armv7_m7)
elseif(${MCUX_DEVICE} MATCHES "MIMXRT(5|6)")
  include_driver_ifdef(CONFIG_HAS_MCUX_CACHE		cache/cache64	driver_cache_cache64)
elseif((${MCUX_DEVICE} MATCHES "MK(28|66)") OR (${MCUX_DEVICE} MATCHES "MKE(14|16|18)") OR (CONFIG_SOC_MIMXRT1166_CM4) OR (CONFIG_SOC_MIMXRT1176_CM4))
  include_driver_ifdef(CONFIG_HAS_MCUX_CACHE		cache/lmem	driver_cache_lmem)
endif()

if (${MCUX_DEVICE} MATCHES "MIMXRT11[0-9][0-9]")
   include_driver_ifdef(CONFIG_PM_MCUX_GPC		gpc_3		driver_gpc_3)
   include_ifdef(CONFIG_HWINFO_MCUX_SRC_V2		driver_soc_src)
elseif (${MCUX_DEVICE} MATCHES "MIMXRT10[0-9][0-9]")
   include_driver_ifdef(CONFIG_PM_MCUX_GPC		gpc_1		driver_gpc_1)
   include_driver_ifdef(CONFIG_PM_MCUX_DCDC		dcdc_1		driver_dcdc_1)
   include_driver_ifdef(CONFIG_PM_MCUX_PMU		pmu		driver_pmu)
endif()

if("${CONFIG_SOC_FAMILY}" STREQUAL "nxp_kinetis")

  include_driver_ifdef(CONFIG_SOC_FLASH_MCUX		flash		driver_flash)

  include(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/port/driver_port.cmake)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/port)

  if(${MCUX_DEVICE} MATCHES "MK(80|82|64|66|M34|M35|E14F|E16F|E18F)")
    include(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/sysmpu/driver_sysmpu.cmake)
    zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/sysmpu)
  endif()

endif()

if("${CONFIG_SOC_FAMILY}" STREQUAL "nxp_lpc")

if ((${MCUX_DEVICE} MATCHES "LPC8[0-9][0-9]") OR (${MCUX_DEVICE} MATCHES "LPC5(1|4)"))
  include_driver_ifdef(CONFIG_SOC_FLASH_MCUX		iap		driver_iap)
  include_driver_ifdef(CONFIG_ENTROPY_MCUX_RNG		iap		driver_rng)
elseif (${MCUX_DEVICE} MATCHES "LPC55")
  include_driver_ifdef(CONFIG_SOC_FLASH_MCUX		iap1		driver_iap1)
  include_driver_ifdef(CONFIG_ENTROPY_MCUX_RNG		rng_1		driver_rng_1)
endif()

if (${MCUX_DEVICE} MATCHES "LPC5")
  include(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iocon/driver_lpc_iocon.cmake)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iocon)
elseif (${MCUX_DEVICE} MATCHES "LPC8")
  include(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iocon_lite/driver_lpc_iocon_lite.cmake)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iocon_lite)
endif()

endif()

if(${MCUX_DEVICE} MATCHES "MIMXRT(5|6)")
  include(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iopctl/driver_lpc_iopctl.cmake)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/drivers/lpc_iopctl)
endif()

#include macro definition
zephyr_compile_definitions_ifdef(CONFIG_NXP_IMX_RT_BOOT_HEADER XIP_BOOT_HEADER_ENABLE=1)
zephyr_compile_definitions_ifdef(CONFIG_NXP_IMX_RT6XX_BOOT_HEADER BOOT_HEADER_ENABLE=1)
zephyr_compile_definitions_ifdef(CONFIG_NXP_IMX_RT5XX_BOOT_HEADER BOOT_HEADER_ENABLE=1)
zephyr_compile_definitions_ifdef(CONFIG_DEVICE_CONFIGURATION_DATA XIP_BOOT_HEADER_DCD_ENABLE=1)
zephyr_compile_definitions(BOARD_FLASH_SIZE=CONFIG_FLASH_SIZE*1024)

if(CONFIG_BOARD_MIMXRT1010_EVK)
  set(MCUX_BOARD evkmimxrt1010)
elseif(CONFIG_BOARD_MIMXRT1015_EVK)
  set(MCUX_BOARD evkmimxrt1015)
elseif(CONFIG_BOARD_MIMXRT1020_EVK)
  set(MCUX_BOARD evkmimxrt1020)
elseif(CONFIG_BOARD_MIMXRT1024_EVK)
  set(MCUX_BOARD evkmimxrt1024)
elseif(CONFIG_BOARD_MIMXRT1050_EVK OR CONFIG_BOARD_MIMXRT1050_EVK_QSPI)
  set(MCUX_BOARD evkbimxrt1050)
if (CONFIG_BOARD_MIMXRT1050_EVK_QSPI)
  set(MCUX_BOARD_MOD _qspi)
endif()
elseif(CONFIG_BOARD_MIMXRT1060_EVK OR CONFIG_BOARD_MIMXRT1060_EVK_HYPERFLASH)
  set(MCUX_BOARD evkmimxrt1060)
elseif(CONFIG_BOARD_MIMXRT1064_EVK)
  set(MCUX_BOARD evkmimxrt1064)
elseif(CONFIG_BOARD_MIMXRT595_EVK)
  set(MCUX_BOARD evkmimxrt595)
elseif(CONFIG_BOARD_MIMXRT685_EVK)
  set(MCUX_BOARD evkmimxrt685)
elseif(CONFIG_BOARD_MIMXRT1170_EVK_CM7 OR CONFIG_BOARD_MIMXRT1170_EVK_CM4)
  set(MCUX_BOARD evkmimxrt1170)
elseif(CONFIG_BOARD_MIMXRT1160_EVK_CM7 OR CONFIG_BOARD_MIMXRT1160_EVK_CM4)
  set(MCUX_BOARD evkmimxrt1160)
endif()

if (${MCUX_BOARD} MATCHES "evk[bm]imxrt1[0-9][0-9][0-9]")

  list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD}/xip
  )
  include_ifdef(CONFIG_BOOT_FLEXSPI_NOR driver_xip_board_${MCUX_BOARD}${MCUX_BOARD_MOD})
  zephyr_library_sources_ifdef(CONFIG_DEVICE_CONFIGURATION_DATA mcux-sdk/boards/${MCUX_BOARD}/dcd.c)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD})

elseif (${MCUX_BOARD} MATCHES "evkmimxrt6[0-9][0-9]")

  list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD}/flash_config
  )
  include_ifdef(CONFIG_NXP_IMX_RT6XX_BOOT_HEADER    driver_flash_config)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD})

elseif (${MCUX_BOARD} MATCHES "evkmimxrt5[0-9][0-9]")

  list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD}/flash_config
  )
  include_ifdef(CONFIG_NXP_IMX_RT5XX_BOOT_HEADER    driver_flash_config)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/boards/${MCUX_BOARD})

endif()

if(CONFIG_ETH_MCUX)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy/device/phyksz8081)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy/device/phyar8031)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy/device/phylan8720a)
  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy/device/phyrtl8211f)
  zephyr_library_sources(mcux-sdk/components/phy/device/phyksz8081/fsl_phyksz8081.c)
  zephyr_library_sources(mcux-sdk/components/phy/device/phyar8031/fsl_phyar8031.c)
  zephyr_library_sources(mcux-sdk/components/phy/device/phylan8720a/fsl_phylan8720a.c)
  zephyr_library_sources(mcux-sdk/components/phy/device/phyrtl8211f/fsl_phyrtl8211f.c)

  zephyr_include_directories(${CMAKE_CURRENT_LIST_DIR}/mcux-sdk/components/phy/mdio/enet)
  zephyr_library_sources(mcux-sdk/components/phy/mdio/enet/fsl_enet_mdio.c)
endif()


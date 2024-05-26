from pynq import Overlay
#import signal
import os
import xrfdc
import xrfclk


class Overlay(Overlay):
    """
    """
    
    def __init__(self, bitfile_name=None, init_rf_clks=True, **kwargs):
        """
        """

        # Generate default bitfile name
        if bitfile_name is None:
            this_dir = os.path.dirname(__file__)
            bitfile_name = os.path.join(this_dir, 'rfsoc_nrssb', 'bitstream', 'rfsoc_nrssb.bit')

        # Create Overlay
        super().__init__(bitfile_name, **kwargs)

        # Determine board and set PLL appropriately
        board = os.environ['BOARD']
        
        # Extract friendly dataconverter names
        if board == 'RFSoC4x2':
            self.dac_tile = self.rfdc.dac_tiles[2]
            self.dac_block = self.dac_tile.blocks[0]
            self.adc_tile = self.rfdc.adc_tiles[2]
            self.adc_block = self.adc_tile.blocks[1]
        elif board in ['ZCU208', 'ZCU216']:
            self.dac_tile = self.rfdc.dac_tiles[2]
            self.dac_block = self.dac_tile.blocks[0]
            self.adc_tile = self.rfdc.adc_tiles[1]
            self.adc_block = self.adc_tile.blocks[0]
        elif board == 'RFSoC2x2':
            self.dac_tile = self.rfdc.dac_tiles[1]
            self.dac_block = self.dac_tile.blocks[0]
            self.adc_tile = self.rfdc.adc_tiles[2]
            self.adc_block = self.adc_tile.blocks[0]
        elif board == 'ZCU111':
            self.dac_tile = self.rfdc.dac_tiles[1]
            self.dac_block = self.dac_tile.blocks[2]
            self.adc_tile = self.rfdc.adc_tiles[0]
            self.adc_block = self.adc_tile.blocks[0]
        else:
            raise RuntimeError('Unknown error occurred.') # shouldn't get here
        
        # Start up LMX clock
        if init_rf_clks:
            clocks.set_custom_lmclks()

        if board == 'ZCU216':
            fs = 1920.00
        else:
            fs = 3840.00

        self.configure_adcs(sample_freq=fs)
        self.configure_dacs()
        

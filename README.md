
![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/27aba886-8823-428a-b0b6-44263d8a1c18)


The steps involved:

1. Simulink Model – SSB Detect
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/a916aa58-6f45-4f62-b5a2-28f211c963ca)

2. HDL Code generation
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/4ae21e45-2480-4156-a708-0427d89fa206)

3. IP Core generation
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/bb8a9916-509d-45f0-a340-39d9bb04a891)

4. Block Design and interconnection
   ![image](https://github.com/himanshudutta11/rfsoc_nrssb/assets/121915091/52887869-9e79-42be-8b38-286fc4d0e1ab)

5. Bitstream generation
 Bitstream is generated through the script - rfsoc_nrssb/boards/RFSoC2x2/rfsoc_nrssb/make_bitstream.tcl
   
6. Invoking IPs from PYNQ framework

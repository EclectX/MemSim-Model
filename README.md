# MemSim+: A Realistic Behavioral Model for ReRAMs Capturing Non-Idealities
This repository presents a technology-specific, realistic memristor behavioral model that incorporates key non-idealities, including cycle-to-cycle and device-to-device resistance variations, threshold voltage variations, resistance drift in the absence of external stimuli, and variations in switching dynamics. The developed SPICE model is implemented in LTSpice and has been fitted to experimental data from two different types of memristors:
1. Vacuum-processed self-directed channel (SDC) memristors
2. Inkjet-printed electrochemical metallization (ECM) memristors

The model parameters have been extracted from experiments and are listed in:
* Table I for nominal values (traditional approach)
* Table II for variation-aware parameters (the proposed approach)

We provide a total of four fitted model files, categorized as follows:

**MemSim+ Nominal Model**  
1. `SDC_nominal`  
2. `ECM_nominal`  

**MemSim+ Variability-Aware Model**  
3. `SDC_variation`  
4. `ECM_variation`

Each folder contains two essential files:
1. **`.asc` file** – Contains the schematic where the obtained parameters from Table I and Table II are applied for the specific technology.
2. **`.asy` file** – Represents the symbol generated from the schematic.

## MemSim+: How to Use
If you don't have LTSpice installed on your system, you can download and install it from [Analog Devices LTSpice Simulator](https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html). <br /> 
1. Download the desired model folder (`SDC_nominal`, `ECM_nominal`, `SDC_variation`, or `ECM_variation`).
2. Open **LTSpice**, create a new schematic for your circuit, and save both the circuit and the memristor model files (both .asc and .asy) in the same folder.
3. To add memristor to the schematic, follow the steps below which is also highlighted in the figure:<br /> 
* Click on the component (a) from the SPICE menu.
* Change the directory path (b) to the location where the model files are saved.
* Select the memristor (c) and click OK.<br /> 
![GetMemristor](https://github.com/user-attachments/assets/7018be2b-0415-456c-b32a-d1986e781fd7)<br /> 
5. Once the components are placed, you are ready to simulate your circuit.<br /> 
### Example Circuit:
To demonstrate how the simulation process works, an example circuit is provided in the **FELIX_variation_SDC** folder. This folder contains:
1. **`Felix_variation.asc`** – The schematic daigram of FELIX-OR gate.
2. **`Memsim+SDC_variation.asc`** and **`Memsim+SDC_variation.asy`** – Required to get the memristor in the schematic as explained above.
3. **`up_Felix_00_0.66.txt`**, **`up_Felix_01_0.66.txt`**, **`up_Felix_10_0.66.txt`**, and **`up_Felix_11_0.66.txt`** are the exported output data from the **LTSpice**.
4. **`Plot_Hist_Exported_Spice_data.m`** - A **MATLAB** script to plot the histogram of the output.<br />   
A **FELIX-OR** gate circuit can be created from the blank schematic by selecting components from the SPICE menu. The memristor is initialized in **HRS** in the model. You can change the state of the memristor by right-clicking on it in the schematic. A window titled **Navigate/Edit Schematic Block** will appear. Then, click on the **PARAMS** block and set the variable:<br /> 
- **`w_init=3n`** to set it to **LRS**
- **`w_init=0n`** to set it to **HRS**<br />  
Now, set the state of the output memristor to **HRS** for FELIX-OR gate by setting the variable **`w_init=0n`**, and configure the input memristors for all input combinations as follows:<br />
- **('00') HRS and HRS** → `w_init=0n` and `w_init=0n`
- **('01') HRS and LRS** → `w_init=0n` and `w_init=3n`
- **('10') LRS and HRS** → `w_init=3n` and `w_init=0n`
- **('11') LRS and LRS** → `w_init=3n` and `w_init=3n`<br /> 
 ![image](https://github.com/user-attachments/assets/7bb88405-f0e8-4556-9408-8dd1b2d91073)<br /> 
The final circuit for the FELIX-OR gate resembles the figure above, and this schematic is ready for simulation with the input combination `01` by clicking **Run**. The schematic simulates the circuit 100 times, which can be modified by changing the command line in the schematic to `.step param run 1 100 1´.  You can then plot the output voltage of the **s** terminal of **out** memristor and view the results in the waveform.<br /> 
Since quantifying the output directly from the waveform can be difficult as can be seen from below figure, the output data can be exported as a `.txt` file.![image](https://github.com/user-attachments/assets/ea9b8c5d-8817-42d6-8a04-26b5edd362df)<br /> 
 To do this:
1. Left-click on the waveform window.
2. Go to **File** menu on the top left corner and select the option **Export data as txt**.
## MATLAB Analysis and Logical Mapping
To analyze the exported `.txt` file, a **MATLAB script** is provided to **plot the histogram** of the output voltage. The script enables classification of **low logic** and **high logic** states using four predefined **logical mapping schemes**:
- **Logical Mapping I**: Low logic (`0 < s < 0.5`), High logic (`0.5 < s < 1`), stored in `LM1_high`, `LM1_low`
- **Logical Mapping II**: Low logic (`0 < s < 0.45`), High logic (`0.55 < s < 1`), stored in `LM2_high`, `LM2_low`
- **Logical Mapping III**: Low logic (`0 < s < 0.33`), High logic (`0.67 < s < 1`), stored in `LM3_high`, `LM3_low`
- **Logical Mapping IV**: Low logic (`0 < s < 0.3`), High logic (`0.7 < s < 1`), stored in `LM4_high`, `LM4_low`
![image](https://github.com/user-attachments/assets/7541499e-4ca3-4d46-8ea0-f9a4f1c4ca5d)<br /> 
The MATLAB screenshot above displays the histogram of the output data for the input combination '10'. In the top right corner, the **Workspace** stores the output logical state according to the corresponding logical mapping schemes. For input '10', the FELIX-OR gate should output 1. In Logical Mapping I, ´LM1_high` stores 92 representing the high logical value, while `LM1_low` represents the low logical value. This indicates that out of 100 runs, the circuit operated correctly 92 times.
The MATLAB script includes detailed comments explaining each step. Additionally, users can **customize their own logical mapping scheme** by adjusting the voltage ranges that define **low logic** and **high logic** states. This allows for flexibility in adapting the analysis based on different threshold levels for logic classification.
## Citation and More Information
For detailed information, check out the full article on **Nature Communications** along with the **Supplementary Information**. If you find this project useful, please star this repository ⭐ and cite the article.

```bibtex
@article{gulafshan2025realistic,
    author = {Gulafshan,G., Hu, H., Radakovits, D. et al.},
    title = {Realistic Behavioral Model for ReRAMs Capturing Non-Idealities},
    journal = {Nature Communications},
    year = {2025}
}

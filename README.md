# **Implicit Wiener Filtering for Speech Enhancement**
This work demonstrates how the adjustment of appropriate hyperparameters of our proposed implicit Wiener filter algorithm can result in a better spectral reconstruction (speech enhancement) of the speech signal in non-stationary noisy environments. For example, in mobile telephony, noise sources with a marked non-stationary spectral signature include vehicles, machines, and other speakers to name a few. Our proposed implicit Wiener filter algorithm recursively estimates the noise power spectral density and reconstructs the target speech signal in the frequency domain by judiciously selecting the hyperparameters. The recursive noise estimation approach relies on the past and the present power spectral values. To evaluate the performance of proposed algorithm, speech uttered by a male and a female speaker degraded by non-stationary noise produced e.g. by babbling, cars, street noise, trains, restaurants, and airport noise are used from the NOIZEUS speech corpus. Objective speech quality measures such as the log-likelihood ratio (LLR), the cepstral distance (CD), and the weighted spectral slope distance (WSS) are calculated for the enhanced speech signals and compared to the conventional spectral subtraction method. Results demonstrate that the proposed algorithm provides consistent and improved enhancement performance with all tested noise types.

# **Requirements:**
* NOIZEUS Speech Corpus (Publicly available)
* Matlab

## **License**
* The project is licensed under the GNU General Public License v3.0.
* You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.en.html

# **Citing Work**
* Rahul Jaiswal and Daniel Romero, Implicit Wiener Filtering for Speech Enhancement In Non-Stationary Noise, 11th IEEE International Conference on Information Science and Technology, (2021), pp. 39-47. https://ieeexplore.ieee.org/document/9440639 



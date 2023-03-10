# **Deep Learning based Speech Quality Model**
This work demonstrates how the selection of an appropriate speech feature can result in better speech quality and fulfilling the expectation of human to perceive better quality of experience (QoE) in noisy environments while using different VoIP applications, such as Microsoft Skype, Apple FaceTime, Google Meet. The internet service provider can measure and monitor the real-time speech quality of the end-user using the deep learning-based speech quality model. Moreover, it could also be helpful to the internet service providers in recognizing the possible impairments in their services and then deploying the QoE management actions to rectify them. To this end, this work investigates a series of deep neural network (DNN)-based objective no-reference speech quality models (SQMs) in accurately measuring speech quality. Three speech features, namely, line spectral frequencies (LSF), mel-frequency cepstral coefficients (MFCC), and multi-resolution auditory model (MRAM) are extracted from the speech signal after processing it through a voice activity detector (VAD). A series of DNN-based SQMs is, then, developed by incorporating either a single or a mixture of speech features. The standard no-reference speech quality prediction model (P.563) is employed as a baseline model. Results demonstrate that the DNN-based SQM trained with the MRAM feature performs better in accurately measuring speech quality as compared to the baseline model and other DNN-based SQMs trained with different speech features or their mixtures.

# **Requirements:**
* NOIZEUS Speech Corpus (Publicly available)
* TensorFlow
* Python

## **License**
* The project is licensed under the GNU General Public License v3.0.
* You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.en.html

# **Citing Work**
* Rahul Jaiswal, Performance Analysis of Deep Learning Based Speech Quality Model with Mixture of Features,
24th IEEE International Symposium on Multimedia (2022), pp. 240-244. https://ieeexplore.ieee.org/document/10019706



# Colorectal Cancer Genetic Risk Assessment System

## Introduction
This platform offers a genetic risk assessment tailored to colorectal cancer. By employing population cohort research methodologies, we discern the genetic characteristics of patients and control groups, pinpointing gene loci implicated in the disease onset. This system can interpret user-submitted gene mutations to deliver a colorectal cancer risk assessment—making it invaluable for genetic risk evaluation and targeted drug selection.

## Pages Overview

### Home Page
The home page is organized into three main sections:
- **Disease Background**: An overview of colorectal cancer and its genetic implications.
- **System Overview**: A brief rundown of what our system offers.
- **Overall Structural Process**: A graphical representation of our methodology and approach.

![Overview](https://github.com/medxiaorudan/ColorectalCancer/blob/master/image/overview.png)

### Upload Page
- Before uploading a VCF file, the system showcases a graphical representation depicting the risk of colorectal cancer within the thousand human genomes.  
![Upload Initial View](https://github.com/medxiaorudan/ColorectalCancer/blob/master/image/upload1.png)

- Post VCF file submission, users can discern their genetic standing within the thousand human genomes, obtain the OR value, and comprehend their relative genetic risk. The ensuing illustration denotes the relative genetic risk of colorectal cancer. The blue arrow signifies the user's relative genetic risk within the thousand human genomes, the curve represents the genetic risk across these genomes, with the horizontal axis depicting the normalized natural log of the relative risk OR, and the vertical axis showing the population probability density corresponding to the OR value.

- If a user uploads a VCF file lacking a risk site within the colorectal cancer-related risk locus database, they'll receive a notification emphasizing the absence of relevant colorectal cancer sites.

## Example of a high risk result

![image](https://github.com/medxiaorudan/ColorectalCancer/assets/22127304/30176ab3-145a-413d-8344-c43023a51e96)


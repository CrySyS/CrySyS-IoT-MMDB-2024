# CrySyS IOT Malware Metadata DataBase 2024

Internet of Things (IoT) devices are becoming increasingly popular and used in various fields (e.g. smart city solutions, healthcare applications, industrial control and automation, agriculture, etc.). However, their increased use has made them vulnerable to attacks by well-known malware families such as Mirai, Gafgyt and Tsunami, which organise these compromised IoT devices into large botnets. To address this threat, the security research community has started to develop methods to detect IoT malware.

Using the Yokohama National University (YNU) [malware datasets](https://sec.ynu.codes/iot/available_datasets#1) [1-2], we have created a metadata database of verified malware binaries. The datasets contain all metadata from the binaries, including information from the binaries themselves (such as ELF header information and file size) and details from the VirusTotal analysis reports (like the first submission date to VirusTotal and antivirus labels assigned by antivirus products). Accurate antivirus labels were generated using [AVClass2](https://github.com/malicialab/avclass). By creating these metadatabases, we want to support the community in using this publicly available metadatabase for various security research and development projects. We publish our metadata databases, called "CrySyS IoT Malware Metadata DataBase 2024", or CrySyS-IoT-MMDB-2024 for short, in a graph-based database called [Neo4j](https://neo4j.com/), which allows users to execute various queries and select specific subsets of IoT malware samples based on their metadata.

## Description of the databases

The CrySyS-IoT-MMDB-2024 consists of 55,497 ELF binaries compiled for the ARM platform and 46,137 ELF binaries compiled for the MIPS platform. The following table shows how many samples were compiled for 32-bit or 64-bit architectures, based on the information in their headers. All samples are executable files.

|        | ARM    | MIPS   |
| ------ | ------ | ------ |
| 32-bit | 55,481 | 46,114 |
| 64-bit | 16     | 20     |

Regarding the linking of ARM and MIPS samples, the following table shows how many samples are linked statically, dynamically, or unknown.

|                    | ARM    | MIPS   |
| ------------------ | ------ | ------ |
| statically linked  | 49,755 | 46,114 |
| dynamically linked | 5,523  | 225    |
| unknown            | 219    | 87     |

The majority of the samples in the datasets are from a few bytes to around 400KB in size. In the ARM dataset, 127 samples are larger than 400 KiB, with the largest file being 8.86 MB. In the MIPS dataset, 225 samples are larger than 400 KiB, with the largest file size being 9.79 MB. 

Based on our entropy analysis of the binaries, we found that the majority of samples in the databases are either native executables or packed. However, there are a few samples with a high entropy value, indicating the presence of encrypted files in the dataset.

## Content of this repository

```
.
|-- README.md
|-- docker-compose.yml
|-- dockerfile
`-- dumps
    |-- arm
    |   `-- neo4j_5.18.1_maintaned.dump
    `-- mips
        `-- neo4j_5.18.1_maintaned.dump
```

`docker-compose.yml`: Configuration file for setting up and managing the Docker container(s) for Neo4j.

`dockerfile`: Instructions to build the Docker image for Neo4j.

`dumps directory`: Contains Neo4j data dumps for different CPU architectures.
- `arm/neo4j_5.18.1_maintaned.dump`: Data dump for ARM architecture.
- `mips/neo4j_5.18.1_maintaned.dump`: Data dump for MIPS architecture.


## How to get the metadata of the malware samples and the binaries themselves?

To access the databases, issue the following command:
`docker compose up --build -d`

The databases are available at the following addresses:
- ARM: `http://localhost:7474`
- MIPS: `http://localhost:7475`

The APIs is available at the following addresses:
- ARM: `neo4j://localhost:7687`
- MIPS: `neo4j://localhost:7688`

The username and the password are: `neo4j/iotmalware` (these parameters can be modified in the `dockerfile`).

It is important to note that container access primarily supports retrieving metadata and does not involve manipulating database content. The data is compiled into the containers, and once the containers are deleted, all modifications are lost.

If persistence is required, it is possible to mount volumes into the containers and store the database files in them (see the commented lines in the `docker-compose.yml` file). In this case however, the dumps must be loaded into the database again using the following command:

```bash
docker exec <container_name> neo4j-admin database load --from-path=/var/lib/neo4j/import --overwrite-destination=true --verbose neo4j
```

The alternative approach is to use dump files, which require the installation of a Neo4j database with a version number equal to or greater than the version number specified in the dump file name. To do this, copy the required dump file to the import folder of Neo4j and issue the following command:

```bash
neo4j-admin database load --from-path=/var/lib/neo4j/import --overwrite-destination=true --verbose neo4j
```

If required, raw binaries can be obtained from the [original datasets](https://sec.ynu.codes/iot/available_datasets#1) using their SHA256 hash value, or samples can be similarly downloaded from VirusTotal.

## Acknowledgement

The CrySyS-IoT-MMDB-2024 data set was compiled as part of the [SETIT Project](https://www.crysys.hu/research/setit/) (2018-1.2.1-NKP-2018-00004), which has been implemented with the support provided from the National Research, Development and Innovation Fund of Hungary, financed under the 2018-1.2.1-NKP funding scheme.

Our work was also supported by the Ministry of Innovation and Technology NRDI Office, Hungary, within the framework of the Artificial Intelligence National Laboratory Program.

The authors are thankful to [VirusTotal](https://www.virustotal.com/) for giving the permission to use data from VirusTotal analysis reports in the construction of the CrySyS-IoT-MMDB-2024 data set.

## References

[1] Yin Minn Pa Pa, Suzuki Shogo, Katsunari Yoshioka, Tsutomu Matsumoto, Takahiro Kasama, Christian Rossow "IoTPOT: A Novel Honeypot for Revealing Current IoT Threats," Journal of Information Processing, Vol.57, No. 4, 2016.

[2] Yin Minn Pa Pa, Shogo Suzuki, Katsunari Yoshioka, and Tsutomu Matsumoto, Takahiro Kasama, Christian Rossow, "IoTPOT: Analysing the Rise of IoT Compromises," 9th USENIX Workshop on Offensive Technologies (USENIX WOOT 2015), 2015.

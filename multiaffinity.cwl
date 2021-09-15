cwlVersion: 'sbg:draft-2'
class: CommandLineTool
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: multiaffinity
label: multiAffinity
baseCommand: []
inputs:
  - type:
      - File
      - type: array
        items: File
    inputBinding:
      position: 0
      secondaryFiles: []
    id: '#counts'
  - type:
      - File
      - type: array
        items: File
    inputBinding:
      position: 0
      secondaryFiles: []
    id: '#layers'
  - type:
      - File
    inputBinding:
      position: 0
      secondaryFiles: []
    id: '#metadata'
outputs:
  - type:
      - 'null'
      - File
    outputBinding:
      glob: multiAffinity-output.txt
    id: '#output'
hints:
  - class: DockerRequirement
    dockerPull: marbatlle/multiaffinity
$author:  
  - class: s:Person
    s:email: mailto:mar.batlle@bsc.es
    s:name: Mar Batlle
import sys

fileIN=open(sys.argv[1], "rU") #transcriptome
fileID=open(sys.argv[2], "rU")	#IDs list to get fasta sequence
fileOUT=open(sys.argv[3], "w")	#out file

ref=dict()



line=fileIN.readline()
seq=""
id=""
nbSeq=0
while line :
	if line.startswith(">") :
		if nbSeq!=0 :
			ref[str(id)]=str(seq)
		id=line.split(" ")[0].replace(">","")
		seq=""
		nbSeq=nbSeq+1
	else :
		seq=seq+line
	line=fileIN.readline()
ref[str(id)]=str(seq)

print("Il y a "+str(nbSeq)+" sequences dans le transcriptome.")
#print(ref)
#print(len(ref.keys()))


dup=dict()
line=fileID.readline()
while(line) :
	line=line.replace("\n","").replace(">","")
	if str(line) != "" :
		if not ref.has_key(line) :
			print("Erreur : sequence "+str(line)+" non presente dans le transcriptome.")	
		elif not dup.has_key(line) :
			fileOUT.write(">"+line+"\n")
			fileOUT.write(ref[line])
	dup[str(line)]=1
	line=fileID.readline()

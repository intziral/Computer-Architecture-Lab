## Πρώτο Εργαστήριο Αρχιτεκτονικής Προηγμένων Υπολογιστών

**Ιωάννης Τζιραλής** ΑΕΜ: 9198
**Ηλίας Κορομπίλης** ΑΕΜ: 8993

### 1. Βασικές Παράμετροι Συστήματος  
Στη main του αρχείου starter_se.py δηλώνονται οι default παράμετροι του συστήματος:  
* Tύπος cpu: atomic
* Συχνότητα λειτουργίας: 4GHz
* Αριθμός πυρήνων: 1
* Είδος κύριας μνήμης: DDR3 1600 8X8
* Κανάλια: 2
* Μέγεθος κύριας μνήμης: 2GB  

Στην εντολή που εκτελούμε εμείς θέσαμε τον τύπο cpu σε minor (--cpu="minor") και οι υπόλοιπες παράμετροι πήραν τις default τιμές τους.

### 2. Τα αρχεία config.ini και config.json  
Όντως τα αρχεία αυτά επαληθεύουν τις πληροφορίες που είχαμε για το σύστημα. Συγκεκριμένα τον τύπο CPU,
>type=MinorCPU

τη συχνότητα λειτουργίας 4GHz (εδώ μετριέται σε ns),
>clock=250

η κύρια μνήμη έχει μέγεθος 2GB και δύο κανάλια
>mem_ramges=0:2147483648  
>memories=system.mem_ctrls0.dram system.mem_ctrls1.dram

και οι caches μέγεθος γραμμής 64 bytes.
>cache_line_size=64


Το συνολικό νούμερο των "committed" εντολών είναι 5028, όπως προκύπτει απο το αρχείο stats.txt:
>system.cpu_cluster.cpus.committedInsts           5028

Η L2 cache προσπελάστηκε 479 φορές, όπως προκύπτει απο το αρχείο stats.txt:
>system.cpu_cluster.l2.overall_accesses::total          479


### 3. Διαφορετικά Μοντέλα in-order CPUs στον gem-5    
Στον gem-5 υπάρχουν τρία μοντέλα in-order CPUs: το MinorCPU, το TimingSimpleCPU και το AtomicSimpleCPU. Τα δύο τελευταία είναι εκδοχές του SimpleCPU μοντέλου.

#### MinorCPU  
Το MinorCPU μοντέλο είναι ένα in-order μοντέλο με σταθερό pipeline αλλά προσαρμοζόμενα data structures και συμπεριφορά εκτέλεσης. Προορίζεται για την εξομειώση επεξεργαστών με αυστηρή in-order execution συμπεριφορά και επιτρέπει την απεικόνιση της θέσης μιας εντολής μέσω του MinorTrace/minorview.py εργαλείου.

#### SimpleCPU  
Το SimpleCPU αποτελεί ένα πολύ απλό στην υλοποίηση in order μοντέλο κατασκευασμένο για χρήση σε απλά τεστ , όπου δεν είναι απαραίτητη η χρήση κάποιου πιο περίπλοκου μοντέλου.

#### AtomicSimpleCPU
Το AtomicSimpleCPU αποτελεί υλοποίηση του SimpleCPU μοντέλου που χρησιμοποιεί πρόσβαση στη μνήμη τύπου atomic(atomic memory access). Αυτό σημαίνει ότι υπολογίζει προσεγγιστικά τον χρόνο πρόσβασης στην cache από τις χρονικές προσεγγίσεις των atomic accesses οι οποίες επιστρέφουν μια προσέγγιση του χρόνου που θα χρειαστούν για το access , ενώ η επιστροφή τιμής γίνεται στο τέλος του access function. Με αυτό τον τρόπο αποφεύγεται το queuing delay και το resource contention διότι η cpu γνωρίζει προσεγγιστικά τον χρόνο πρόσβασης στην μνήμη πριν αυτή ολοκληρωθεί.

#### TimingSimpleCPU
Το TimingSimpleCPU αποτελεί υλοποίηση του SimpleCPU μοντέλου που χρησιμοποιεί πρόσβαση στη μνήμη τύπου timing(timing memory access). Αυτό σημαίνει ότι σε κάθε πρόσβαση στην cache καθυστερεί και περιμένει την απάντηση από το σύστημα μνήμης (είτε NACK εάν δεν μπορούσε να ολοκληρωθεί το αίτημα είτε την τιμή στην μνήμη που ζητήθηκε) πριν συνεχίσει την εκτέλεση εντολών ,υπάρχει δηλαδή resource contention και queuing delay , αφού ο επεξεργαστής περιμένει την ολοκλήρωση της πρόσβασης στην μνήμη για να συνεχίσει.

### Πηγές  
* gem5 documentation: [MinorCPU](http://www.gem5.org/documentation/general_docs/cpu_models/minor_cpu)
* gem5 documentation: [SimpleCPU](http://www.gem5.org/documentation/general_docs/cpu_models/SimpleCPU)

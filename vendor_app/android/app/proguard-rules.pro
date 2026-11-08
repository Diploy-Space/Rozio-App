# WorkManager (used by flutter_downloader) instantiates its Room database
# implementation reflectively at runtime. Its own consumer rules only keep
# Worker/ListenableWorker/InputMerger classes, not the generated Room *_Impl
# classes, so R8 strips/renames WorkDatabase_Impl in release builds and the
# app crashes on startup with:
#   RuntimeException: Failed to create an instance of class androidx.work.impl.WorkDatabase
-keep class * extends androidx.room.RoomDatabase
-keep class **_Impl { *; }
-keep class **_Impl$* { *; }

# WorkManager instantiates InputMergers and Workers reflectively through their
# constructors. Its consumer rule (-keep class * extends InputMerger) keeps only
# the class; under R8 full mode that no longer keeps the no-arg constructor, so
# every job (including flutter_downloader's DownloadWorker) fails with:
#   NoSuchMethodException: androidx.work.OverwritingInputMerger.<init> []
-keep class * extends androidx.work.InputMerger { public <init>(); }
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

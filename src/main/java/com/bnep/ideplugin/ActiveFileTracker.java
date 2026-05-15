package com.bnep.ideplugin;

import com.intellij.openapi.diagnostic.Logger;
import com.intellij.openapi.fileEditor.FileEditorManager;
import com.intellij.openapi.fileEditor.FileEditorManagerEvent;
import com.intellij.openapi.fileEditor.FileEditorManagerListener;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.project.ProjectManager;
import com.intellij.openapi.project.ProjectManagerListener;
import com.intellij.openapi.startup.StartupActivity;
import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ActiveFileTracker implements StartupActivity {

    private static final Logger LOG = Logger.getInstance(ActiveFileTracker.class);
    private static final Path TARGET = Paths.get(System.getProperty("user.home"), ".claude", "active_file.txt");

    @Override
    public void runActivity(@NotNull Project project) {
        registerForProject(project);
    }

    private static void registerForProject(Project project) {
        project.getMessageBus().connect().subscribe(
                FileEditorManagerListener.FILE_EDITOR_MANAGER,
                new FileEditorManagerListener() {
                    @Override
                    public void selectionChanged(@NotNull FileEditorManagerEvent event) {
                        if (event.getNewFile() != null) {
                            writeActiveFile(event.getNewFile().getPath());
                        }
                    }
                }
        );

        var files = FileEditorManager.getInstance(project).getSelectedFiles();
        if (files.length > 0) {
            writeActiveFile(files[0].getPath());
        }
    }

    private static void writeActiveFile(String path) {
        try {
            Files.createDirectories(TARGET.getParent());
            Files.writeString(TARGET, path, StandardCharsets.UTF_8);
        } catch (IOException e) {
            LOG.warn("Failed to write active file: " + path, e);
        }
    }
}

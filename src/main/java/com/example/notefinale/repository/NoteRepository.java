package com.example.notefinale.repository;

import com.example.notefinale.model.Note;
import com.example.notefinale.model.Candidat;
import com.example.notefinale.model.Matiere;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoteRepository extends JpaRepository<Note, Long> {
    
    @Query("SELECT n FROM Note n WHERE n.candidat.id = :candidatId AND n.matiere.id = :matiereId")
    List<Note> findByCandidatAndMatiere(@Param("candidatId") Long candidatId, @Param("matiereId") Long matiereId);
    
    @Query("SELECT n FROM Note n WHERE n.candidat.id = :candidatId")
    List<Note> findByCandidatId(@Param("candidatId") Long candidatId);
}

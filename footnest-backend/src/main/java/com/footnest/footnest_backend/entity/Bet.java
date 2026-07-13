package com.footnest.footnest_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "bets")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Bet {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;


    @Column(nullable = false)
    private String name;


    private LocalDateTime createdAt = LocalDateTime.now();


    @OneToMany(mappedBy = "bet")
    private List<BetSelection> selections = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private BetStatus status = BetStatus.OPEN;

    public enum BetStatus {
        OPEN,
        WON,
        LOST,
    }

}